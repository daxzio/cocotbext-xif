"""

Copyright (c) 2024-2025 Daxzio

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
from typing import Any, Deque, Dict, Optional, Sequence, Union

from cocotb import start_soon
from cocotb.triggers import Event, ReadOnly, RisingEdge

from .constants import XifMode
from .memory import Memory
from .transaction import IdAllocator, XifInsn, XifMemReq, XifResult
from .xif_base import XifBase


class XifHost(XifBase):
    """CPU-side XIF driver: issue, commit, result, and memory channels."""

    def __init__(
        self,
        bus,
        clock,
        reset=None,
        reset_active_level: bool = False,
        timeout_max: int = 100,
        mem: Optional[Memory] = None,
        commit_delay: int = 1,
        **kwargs,
    ) -> None:
        super().__init__(
            bus,
            clock,
            name="host",
            reset=reset,
            reset_active_level=reset_active_level,
            **kwargs,
        )

        self.timeout_max = timeout_max
        self.mem = mem
        self.commit_delay = commit_delay

        self._ids = IdAllocator(self.id_width)
        self._issue_queue: Deque[XifInsn] = deque()
        self._pending: Dict[int, XifInsn] = {}
        self._result_events: Dict[int, Event] = {}
        self._results: Dict[int, XifResult] = {}
        self._idle = Event()
        self._idle.set()
        self._issue_busy = False

        self._init_host_signals()

        self._issue_coroutine: Any = start_soon(self._run_issue())
        self._result_coroutine: Any = start_soon(self._run_result())
        if self.mem is not None:
            self._mem_coroutine: Any = start_soon(self._run_mem())
        else:
            self._mem_coroutine = None

    def _init_host_signals(self) -> None:
        self.bus.issue_valid.value = 0
        self.bus.issue_req_instr.value = 0
        self.bus.issue_req_mode.value = 0
        self.bus.issue_req_id.value = 0
        self.bus.issue_req_rs_0.value = 0
        self.bus.issue_req_rs_1.value = 0
        if self.bus.has_rs_2:
            self.bus.issue_req_rs_2.value = 0
        self.bus.issue_req_rs_valid.value = 0

        self.bus.commit_valid.value = 0
        self.bus.commit_id.value = 0
        self.bus.commit_kill.value = 0

        self.bus.result_ready.value = 1

        self.bus.mem_ready.value = 1
        self.bus.mem_resp_exc.value = 0
        self.bus.mem_resp_exccode.value = 0
        self.bus.mem_result_valid.value = 0
        self.bus.mem_result_id.value = 0
        self.bus.mem_result_rdata.value = 0
        self.bus.mem_result_err.value = 0

    @property
    def idle(self) -> bool:
        return not self._issue_queue and not self._pending and not self._issue_busy

    async def wait_idle(self) -> None:
        while not self.idle:
            await RisingEdge(self.clock)

    def issue_nowait(self, insn: XifInsn) -> XifInsn:
        """Queue an instruction for issue. Returns the same object with ``id`` set."""
        insn.id = self._ids.alloc()
        self._issue_queue.append(insn)
        self._result_events[insn.id] = Event()
        self._idle.clear()
        return insn

    async def wait(
        self,
        insn: XifInsn,
        *,
        wait_result: bool = True,
        wait_ready_after: bool = False,
    ) -> XifResult | None:
        """Wait for the result of a previously issued instruction."""
        if wait_result:
            event = self._result_events.get(insn.id)
            if event is None:
                raise KeyError(f"No outstanding instruction with id {insn.id}")

            timeout = 0
            while not event.is_set() and timeout < self.timeout_max:
                await RisingEdge(self.clock)
                timeout += 1
            if timeout >= self.timeout_max:
                raise TimeoutError(
                    f"Timeout waiting for result id {insn.id} "
                    f"within {self.timeout_max} cycles"
                )

            result = self._results[insn.id]
            self._check_result(insn, result)
        else:
            result = None

        if wait_ready_after:
            await self._wait_issue_ready()

        return result

    async def _wait_issue_ready(self) -> None:
        timeout = 0
        while int(self.bus.issue_ready.value) != 1 and timeout < self.timeout_max:
            await RisingEdge(self.clock)
            timeout += 1
        if timeout >= self.timeout_max:
            raise TimeoutError(
                "Timeout waiting for issue_ready after multi-cycle operation"
            )

    async def execute(
        self,
        instr: int,
        rs: Sequence[int] = (0, 0, 0),
        rs_valid: int | None = None,
        mode: XifMode = XifMode.MMODE,
        expected: int | None = None,
        check_we: bool = True,
        commit: bool = True,
        kill: int = 0,
        wait_ready_after: bool = False,
        wait_result: bool | None = None,
    ) -> XifResult | None:
        """Issue one instruction, optionally commit, and wait for the result."""
        if wait_result is None:
            wait_result = expected is not None or check_we

        txn = XifInsn(
            instr=instr,
            rs=self.normalize_rs(rs),
            rs_valid=rs_valid,
            mode=mode,
            expected=expected,
            check_we=check_we,
        )
        self.issue_nowait(txn)
        await self._wait_accepted(txn)
        if commit:
            await self.commit(txn.id, wait_cycle=self.commit_delay, kill=kill)
        return await self.wait(
            txn, wait_result=wait_result, wait_ready_after=wait_ready_after
        )

    async def _wait_accepted(self, insn: XifInsn) -> None:
        timeout = 0
        while not insn.accepted and timeout < self.timeout_max:
            await RisingEdge(self.clock)
            timeout += 1
        if not insn.accepted:
            raise TimeoutError(
                f"Timeout waiting for issue accept on id {insn.id} "
                f"within {self.timeout_max} cycles"
            )

    async def commit(self, txn_id: int, wait_cycle: int = 1, kill: int = 0) -> None:
        """Drive the commit channel for a previously accepted instruction."""
        for _ in range(wait_cycle):
            await RisingEdge(self.clock)
        self.bus.commit_valid.value = 1
        self.bus.commit_id.value = txn_id
        self.bus.commit_kill.value = kill
        await RisingEdge(self.clock)
        self.bus.commit_valid.value = 0
        self.bus.commit_id.value = 0
        self.bus.commit_kill.value = 0
        if txn_id in self._pending:
            self._pending[txn_id].committed = True

    def _clear_issue_req(self) -> None:
        self.bus.issue_valid.value = 0
        self.bus.issue_req_instr.value = 0
        self.bus.issue_req_mode.value = 0
        self.bus.issue_req_id.value = 0
        self.bus.issue_req_rs_0.value = 0
        self.bus.issue_req_rs_1.value = 0
        if self.bus.has_rs_2:
            self.bus.issue_req_rs_2.value = 0
        self.bus.issue_req_rs_valid.value = 0

    def _drive_issue_req(self, insn: XifInsn) -> None:
        rs = self.normalize_rs(insn.rs)
        self.bus.issue_valid.value = 1
        self.bus.issue_req_instr.value = self.mask_x(insn.instr)
        self.bus.issue_req_mode.value = int(insn.mode)
        self.bus.issue_req_id.value = insn.id
        self.bus.issue_req_rs_0.value = rs[0]
        self.bus.issue_req_rs_1.value = rs[1]
        if self.bus.has_rs_2:
            self.bus.issue_req_rs_2.value = rs[2] if len(rs) > 2 else 0
        self.bus.issue_req_rs_valid.value = self.default_rs_valid(insn.rs_valid)

    async def _run_issue(self) -> None:
        await self._wait_reset_release()
        while True:
            if not self._issue_queue:
                self._issue_busy = False
                if not self._pending:
                    self._idle.set()
                await RisingEdge(self.clock)
                continue

            self._issue_busy = True
            insn = self._issue_queue.popleft()

            self._drive_issue_req(insn)
            await ReadOnly()
            comb_accept = int(self.bus.issue_resp_accept.value)
            await RisingEdge(self.clock)

            timeout = 0
            while int(self.bus.issue_ready.value) != 1 and timeout < self.timeout_max:
                await RisingEdge(self.clock)
                timeout += 1
            if timeout >= self.timeout_max:
                self._clear_issue_req()
                raise TimeoutError(
                    f"Timeout waiting for issue_ready during id {insn.id}"
                )

            accepted = int(self.bus.issue_resp_accept.value)
            self._clear_issue_req()

            if not accepted:
                self._ids.release(insn.id)
                self._result_events.pop(insn.id, None)
                raise RuntimeError(
                    f"Instruction 0x{insn.instr:08x} (id {insn.id}) not accepted"
                )
            if not comb_accept:
                self.log.warning(
                    "Instruction 0x%08x (id %d) not accepted combinatorially",
                    insn.instr,
                    insn.id,
                )

            insn.accepted = True
            self._pending[insn.id] = insn
            self.log.debug(
                "Instruction 0x%08x accepted (id %d)", insn.instr, insn.id
            )

    async def _run_result(self) -> None:
        await self._wait_reset_release()
        while True:
            await RisingEdge(self.clock)
            if int(self.bus.result_valid.value) != 1:
                continue
            if int(self.bus.result_ready.value) != 1:
                continue

            txn_id = int(self.bus.result_id.value)
            result = XifResult(
                id=txn_id,
                data=self.mask_x(int(self.bus.result_data.value)),
                rd=int(self.bus.result_rd.value),
                we=bool(int(self.bus.result_we.value)),
                exc=bool(int(self.bus.result_exc.value)),
                exccode=int(self.bus.result_exccode.value),
            )

            self._results[txn_id] = result
            event = self._result_events.get(txn_id)
            if event is not None:
                event.set()

            self._pending.pop(txn_id, None)
            self._ids.release(txn_id)

            if not self._issue_queue and not self._pending and not self._issue_busy:
                self._idle.set()

    def _check_result(self, insn: XifInsn, result: XifResult) -> None:
        if result.id != insn.id:
            raise RuntimeError(
                f"Result ID mismatch: got {result.id}, expected {insn.id}"
            )
        if insn.expected is not None:
            expected = self.mask_x(insn.expected)
            if result.data != expected:
                raise RuntimeError(
                    f"Result data mismatch for id {insn.id}: "
                    f"got 0x{result.data:0{width}x}, expected 0x{expected:0{width}x}".format(
                        width=max(1, self.xlen // 4)
                    )
                )
        if insn.check_we and not result.we:
            raise RuntimeError(f"Write enable not set for id {insn.id}")

    async def _run_mem(self) -> None:
        assert self.mem is not None
        await self._wait_reset_release()
        while True:
            await RisingEdge(self.clock)
            if int(self.bus.mem_valid.value) != 1:
                continue
            if int(self.bus.mem_ready.value) != 1:
                continue

            req = XifMemReq(
                id=int(self.bus.mem_req_id.value),
                addr=int(self.bus.mem_req_addr.value),
                mode=XifMode(int(self.bus.mem_req_mode.value)),
                we=bool(int(self.bus.mem_req_we.value)),
                size=int(self.bus.mem_req_size.value),
                be=int(self.bus.mem_req_be.value),
                wdata=self.mask_x(int(self.bus.mem_req_wdata.value)),
                last=bool(int(self.bus.mem_req_last.value)),
            )

            err = False
            rdata = 0
            try:
                rdata = await self._handle_mem_req(req)
            except Exception as exc:
                self.log.warning(
                    "Memory access failed id %d addr 0x%x: %s",
                    req.id,
                    req.addr,
                    exc,
                )
                err = True

            self.bus.mem_result_valid.value = 1
            self.bus.mem_result_id.value = req.id
            self.bus.mem_result_rdata.value = rdata & self.mem_data_mask
            self.bus.mem_result_err.value = int(err)
            await RisingEdge(self.clock)
            self.bus.mem_result_valid.value = 0
            self.bus.mem_result_id.value = 0
            self.bus.mem_result_rdata.value = 0
            self.bus.mem_result_err.value = 0

    async def _handle_mem_req(self, req: XifMemReq) -> int:
        assert self.mem is not None
        size_bytes = max(1, 1 << req.size)
        addr = req.addr
        if req.we:
            data = req.wdata.to_bytes(
                (self.mem_data_width + 7) // 8, byteorder="little"
            )
            if self.mem_be_width:
                for i in range(min(len(data), self.mem_be_width)):
                    if (req.be >> i) & 1:
                        self.mem.write_byte(addr + i, data[i])
            else:
                self.mem.write(addr, data[:size_bytes])
            self.log.debug("Mem write id %d addr 0x%x", req.id, addr)
            return 0

        length = size_bytes
        raw = self.mem.read(addr, length)
        rdata = int.from_bytes(
            raw.ljust((self.mem_data_width + 7) // 8, b"\x00"),
            byteorder="little",
        )
        self.log.debug(
            "Mem read id %d addr 0x%x -> 0x%x", req.id, addr, rdata
        )
        return rdata
