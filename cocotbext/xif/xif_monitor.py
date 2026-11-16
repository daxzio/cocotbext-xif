"""

Copyright (c) 2024-2026 Daxzio

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

"""

from __future__ import annotations

from collections import deque
from dataclasses import dataclass
from typing import Any

from cocotb import start_soon
from cocotb.triggers import ReadOnly, RisingEdge
from cocotb.utils import get_sim_time

from .utils import resolve_x_int
from .xif_base import XifBase


@dataclass
class XifMonitorRecord:
    channel: str
    cycle: int
    txn_id: int
    data: dict


class XifMonitor(XifBase):
    """Passive observer for all four XIF channels."""

    def __init__(self, bus, clock, check_protocol: bool = False, **kwargs) -> None:
        super().__init__(bus, clock, name="monitor", log_quiet=True, **kwargs)
        self.check_protocol = check_protocol
        self.timeout_max = 1000

        self.records: deque[XifMonitorRecord] = deque()
        self._issued_ids: set[int] = set()
        self._committed_ids: set[int] = set()
        self._result_ids: set[int] = set()

        self._issue_valid = 0
        self._issue_ready = 0
        self._issue_req_id = 0
        self._issue_req_instr = 0
        self._issue_req_mode = 0
        self._issue_req_rs_0 = 0
        self._issue_req_rs_1 = 0
        self._issue_req_rs_valid = 0
        self._mem_valid = 0
        self._mem_ready = 0
        self._commit_valid = 0
        self._commit_id = 0
        self._result_valid = 0
        self._result_id = 0

        self._run_coroutine: Any = start_soon(self._run())
        self._resolve_coroutine = None
        self._check_sync_coroutines: list[Any] = []

    def enable_check_sync(self) -> None:
        self.disable_check_sync()
        self._last_clk_time = get_sim_time()
        self._check_sync_coroutines.append(start_soon(self._check_sync_clock()))
        for name in self.bus._signals:
            if hasattr(self.bus, name):
                self._check_sync_coroutines.append(
                    start_soon(self._check_sync_signal(name, getattr(self.bus, name)))
                )

    def disable_check_sync(self) -> None:
        for coro in self._check_sync_coroutines:
            coro.kill()
        self._check_sync_coroutines.clear()

    async def _check_sync_clock(self) -> None:
        while True:
            await RisingEdge(self.clock)
            self._last_clk_time = get_sim_time()

    async def _check_sync_signal(self, name: str, signal: Any) -> None:
        while True:
            await signal.value_change
            if get_sim_time() != self._last_clk_time:
                await ReadOnly()
                if get_sim_time() != self._last_clk_time:
                    self.log.error(
                        f"Signal {name} changed at {get_sim_time()}, "
                        f"which is not aligned with the last clock edge "
                        f"at {self._last_clk_time}"
                    )

    def _sample_bus(self) -> None:
        for sig in self.bus._signals:
            if hasattr(self.bus, sig) and getattr(self.bus, sig) is not None:
                setattr(self, f"_{sig}", resolve_x_int(getattr(self.bus, sig)))

    async def _run(self) -> None:
        prev_issue_valid = 0
        prev_issue_req_id = 0
        prev_issue_req_instr = 0
        stall_timeout = 0

        while True:
            await RisingEdge(self.clock)
            await ReadOnly()
            self._sample_bus()
            cycle = int(get_sim_time("ns"))

            if self._issue_valid and not self._issue_ready:
                stall_timeout += 1
                if (
                    self.check_protocol
                    and prev_issue_valid
                    and prev_issue_req_id == self._issue_req_id
                    and prev_issue_req_instr == self._issue_req_instr
                ):
                    pass
                elif (
                    self.check_protocol
                    and prev_issue_valid
                    and (
                        prev_issue_req_id != self._issue_req_id
                        or prev_issue_req_instr != self._issue_req_instr
                    )
                ):
                    self.log.error(
                        "Issue request changed while issue_ready was low "
                        "(id %d -> %d)",
                        prev_issue_req_id,
                        self._issue_req_id,
                    )
                if stall_timeout >= self.timeout_max:
                    raise TimeoutError(
                        f"issue_ready stall exceeded {self.timeout_max} cycles"
                    )
            else:
                stall_timeout = 0

            if self._issue_valid and self._issue_ready:
                txn_id = self._issue_req_id
                self._issued_ids.add(txn_id)
                rec = XifMonitorRecord(
                    channel="issue",
                    cycle=cycle,
                    txn_id=txn_id,
                    data={
                        "instr": self._issue_req_instr,
                        "mode": self._issue_req_mode,
                        "rs_0": self._issue_req_rs_0,
                        "rs_1": self._issue_req_rs_1,
                        "rs_valid": self._issue_req_rs_valid,
                    },
                )
                self.records.append(rec)
                self.log.debug(
                    "Issue id=%d instr=0x%08x mode=%d rs0=0x%x rs1=0x%x rs_valid=%d",
                    txn_id,
                    self._issue_req_instr,
                    self._issue_req_mode,
                    self._issue_req_rs_0,
                    self._issue_req_rs_1,
                    self._issue_req_rs_valid,
                )

            if self._commit_valid:
                txn_id = self._commit_id
                self._committed_ids.add(txn_id)
                self.records.append(
                    XifMonitorRecord(
                        channel="commit",
                        cycle=cycle,
                        txn_id=txn_id,
                        data={},
                    )
                )
                if self.check_protocol and txn_id not in self._issued_ids:
                    self.log.error("Commit for id %d that was never issued", txn_id)

            if self._result_valid:
                txn_id = self._result_id
                self._result_ids.add(txn_id)
                self.records.append(
                    XifMonitorRecord(
                        channel="result",
                        cycle=cycle,
                        txn_id=txn_id,
                        data={"id": txn_id},
                    )
                )
                if self.check_protocol and txn_id not in self._committed_ids:
                    self.log.error("Result for id %d before commit", txn_id)
                if self.check_protocol and txn_id not in self._issued_ids:
                    self.log.error("Result for id %d that was never issued", txn_id)

            if self._mem_valid and self._mem_ready:
                self.records.append(
                    XifMonitorRecord(
                        channel="mem",
                        cycle=cycle,
                        txn_id=resolve_x_int(self.bus.mem_req_id),
                        data={
                            "addr": resolve_x_int(self.bus.mem_req_addr),
                            "we": resolve_x_int(self.bus.mem_req_we),
                        },
                    )
                )

            prev_issue_valid = self._issue_valid
            prev_issue_req_id = self._issue_req_id
            prev_issue_req_instr = self._issue_req_instr
