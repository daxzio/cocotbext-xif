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
from collections.abc import Callable
from typing import Any

from cocotb import start_soon
from cocotb.triggers import RisingEdge

from .constants import XifMode
from .memory import Memory
from .transaction import IdAllocator, XifInsn
from .xif_base import XifBase

Handler = Callable[[XifInsn], int | None]


class XifDevice(XifBase):
    """Coprocessor-side XIF model: accepts issue, drives result and mem channels."""

    def __init__(
        self,
        bus,
        clock,
        reset=None,
        reset_active_level: bool = False,
        handler: Handler | None = None,
        mem: Memory | None = None,
        latency: int = 0,
        accept_delay: int = 0,
        **kwargs,
    ) -> None:
        super().__init__(
            bus,
            clock,
            name="device",
            reset=reset,
            reset_active_level=reset_active_level,
            **kwargs,
        )

        self.handler = handler
        self.mem = mem
        self.latency = latency
        self.accept_delay = accept_delay

        self._ids = IdAllocator(self.id_width)
        self._issue_queue: deque[XifInsn] = deque()
        self._pending: dict[int, XifInsn] = {}

        self._init_device_signals()

        self._issue_coroutine: Any = start_soon(self._run_issue())
        self._commit_coroutine: Any = start_soon(self._run_commit())
        self._result_coroutine: Any = start_soon(self._run_result())
        if self.mem is not None:
            self._mem_coroutine: Any = start_soon(self._run_mem())

    def _init_device_signals(self) -> None:
        self.bus.issue_ready.value = 1
        self.bus.issue_resp_accept.value = 0
        self.bus.issue_resp_writeback.value = 0
        self.bus.issue_resp_dualwrite.value = 0
        self.bus.issue_resp_dualread.value = 0
        self.bus.issue_resp_loadstore.value = 0
        self.bus.issue_resp_exc.value = 0

        self.bus.mem_valid.value = 0
        self.bus.mem_req_id.value = 0
        self.bus.mem_req_addr.value = 0
        self.bus.mem_req_mode.value = 0
        self.bus.mem_req_we.value = 0
        self.bus.mem_req_size.value = 0
        self.bus.mem_req_be.value = 0
        self.bus.mem_req_wdata.value = 0
        self.bus.mem_req_last.value = 0

        self.bus.result_valid.value = 0
        self.bus.result_id.value = 0
        self.bus.result_data.value = 0
        self.bus.result_rd.value = 0
        self.bus.result_we.value = 0
        self.bus.result_exc.value = 0
        self.bus.result_exccode.value = 0

    def queue_insn(self, insn: XifInsn) -> XifInsn:
        """Software model: enqueue a response for an instruction handled internally."""
        if insn.id == 0:
            insn.id = self._ids.alloc()
        self._issue_queue.append(insn)
        self._pending[insn.id] = insn
        return insn

    async def drive_result(
        self,
        txn_id: int,
        data: int,
        rd: int = 0,
        we: bool = True,
        exc: bool = False,
        exccode: int = 0,
    ) -> None:
        for _ in range(self.latency):
            await RisingEdge(self.clock)
        self.bus.result_valid.value = 1
        self.bus.result_id.value = txn_id
        self.bus.result_data.value = self.mask_x(data)
        self.bus.result_rd.value = rd
        self.bus.result_we.value = int(we)
        self.bus.result_exc.value = int(exc)
        self.bus.result_exccode.value = exccode
        await RisingEdge(self.clock)
        self.bus.result_valid.value = 0
        self.bus.result_id.value = 0
        self.bus.result_data.value = 0
        self.bus.result_rd.value = 0
        self.bus.result_we.value = 0
        self.bus.result_exc.value = 0
        self.bus.result_exccode.value = 0
        self._pending.pop(txn_id, None)
        self._ids.release(txn_id)

    async def _run_issue(self) -> None:
        await self._wait_reset_release()
        while True:
            await RisingEdge(self.clock)
            if int(self.bus.issue_valid.value) != 1:
                self.bus.issue_resp_accept.value = 0
                continue

            for _ in range(self.accept_delay):
                await RisingEdge(self.clock)

            rs = self.normalize_rs(
                (
                    int(self.bus.issue_req_rs_0.value),
                    int(self.bus.issue_req_rs_1.value),
                    int(self.bus.issue_req_rs_2.value)
                    if self.bus.has_rs_2
                    else 0,
                )
            )
            insn = XifInsn(
                instr=self.mask_x(int(self.bus.issue_req_instr.value)),
                rs=rs,
                rs_valid=int(self.bus.issue_req_rs_valid.value),
                mode=XifMode(int(self.bus.issue_req_mode.value)),
                id=int(self.bus.issue_req_id.value),
            )
            self._pending[insn.id] = insn
            self.bus.issue_resp_accept.value = 1
            self.bus.issue_resp_writeback.value = 1
            self.log.debug(
                "Accepted issue id=%d instr=0x%08x", insn.id, insn.instr
            )

    async def _run_commit(self) -> None:
        await self._wait_reset_release()
        while True:
            await RisingEdge(self.clock)
            if int(self.bus.commit_valid.value) != 1:
                continue
            txn_id = int(self.bus.commit_id.value)
            kill = bool(int(self.bus.commit_kill.value))
            insn = self._pending.get(txn_id)
            if insn is None:
                self.log.warning("Commit for unknown id %d", txn_id)
                continue
            if kill:
                self._pending.pop(txn_id, None)
                self._ids.release(txn_id)
                continue
            insn.committed = True
            if self.handler is not None:
                result_data = self.handler(insn)
                if result_data is not None:
                    await self.drive_result(txn_id, result_data)

    async def _run_result(self) -> None:
        await self._wait_reset_release()
        while True:
            await RisingEdge(self.clock)

    async def _run_mem(self) -> None:
        assert self.mem is not None
        await self._wait_reset_release()
        while True:
            await RisingEdge(self.clock)
            if int(self.bus.mem_result_valid.value) != 1:
                continue
            txn_id = int(self.bus.mem_result_id.value)
            rdata = self.mask_x(int(self.bus.mem_result_rdata.value))
            err = bool(int(self.bus.mem_result_err.value))
            self.log.debug(
                "Mem result id=%d rdata=0x%x err=%s", txn_id, rdata, err
            )

    async def mem_request(
        self,
        addr: int,
        we: bool = False,
        wdata: int = 0,
        size: int = 2,
        be: int | None = None,
        mode: XifMode = XifMode.MMODE,
        last: bool = True,
    ) -> None:
        """Drive a memory request from the coprocessor."""
        txn_id = self._ids.alloc()
        if be is None:
            be = (1 << (1 << size)) - 1
        self.bus.mem_valid.value = 1
        self.bus.mem_req_id.value = txn_id
        self.bus.mem_req_addr.value = addr
        self.bus.mem_req_mode.value = int(mode)
        self.bus.mem_req_we.value = int(we)
        self.bus.mem_req_size.value = size
        self.bus.mem_req_be.value = be
        self.bus.mem_req_wdata.value = self.mask_x(wdata)
        self.bus.mem_req_last.value = int(last)
        await RisingEdge(self.clock)
        while int(self.bus.mem_ready.value) != 1:
            await RisingEdge(self.clock)
        self.bus.mem_valid.value = 0
        self.bus.mem_req_id.value = 0
        self.bus.mem_req_addr.value = 0
        self.bus.mem_req_mode.value = 0
        self.bus.mem_req_we.value = 0
        self.bus.mem_req_size.value = 0
        self.bus.mem_req_be.value = 0
        self.bus.mem_req_wdata.value = 0
        self.bus.mem_req_last.value = 0
        self._ids.release(txn_id)
