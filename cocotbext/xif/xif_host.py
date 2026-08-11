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

import re
import logging
import math

from cocotb import start_soon
from cocotb.triggers import RisingEdge, FallingEdge, ReadOnly

from collections import deque
from cocotb.triggers import Event
from typing import Deque
from typing import Tuple
from typing import Any
from typing import Union
from typing import Dict

from .xif_base import XifBase
#rom .constants import XifProt
from .constants import XifMode
from .utils import resolve_x_int

# def build_bitrev_instr(rd, rs1):
#     """Build a BITREV instruction
#     Format: funct7[31:25] | rs2[24:20] | rs1[19:15] | funct3[14:12] | rd[11:7] | opcode[6:0]
#     BITREV: 0000010 | 00000 | rs1 | 111 | rd | 0101011
#     """
#     instr = 0
#     instr |= 0x2B                # opcode [6:0] = 0101011
#     instr |= (rd & 0x1F) << 7    # rd [11:7]
#     instr |= 0x7 << 12           # funct3 [14:12] = 111
#     instr |= (rs1 & 0x1F) << 15  # rs1 [19:15]
#     instr |= 0x0 << 20           # rs2 [24:20] = 00000 (unused)
#     instr |= 0x02 << 25          # funct7 [31:25] = 0000010
#     return instr

class XifHost(XifBase):
    def __init__(self, bus, clock, timeout_max=100, **kwargs) -> None:
        super().__init__(bus, clock, name="host", **kwargs)

        self.timeout_max = timeout_max
        # self.exception_enabled = True
        # self.exception_occurred = False

        # self.queue_tx: Deque[
        #     Tuple[bool, int, bytes, int, XifProt, bool, int, int]
        # ] = deque()
        #self.queue_rx: Deque[Tuple[bytes, int]] = deque()
        self.tx_id = 1
        self.return_int = False
        self.ret: Union[bytes, None] = None
        self.intra_delay: int = 0
        self.addrmap: Dict[int, Dict[str, int]] = {}

        self._idle = Event()

        self.bus.issue_valid.value = 0
        # self.bus.issue_ready.value = 1
        self.bus.issue_req_instr.value = 0
        self.bus.issue_req_mode.value = 0
        self.bus.issue_req_id.value = 0
        self.bus.issue_req_rs_0.value = 0
        self.bus.issue_req_rs_1.value = 0
        self.bus.issue_req_rs_valid.value = 0
        # self.bus.issue_req_ecs.value = 0
        # self.bus.issue_req_ecs_valid.value = 0

        self.bus.mem_ready.value = 1
        self.bus.mem_resp_exc.value = 0
        self.bus.mem_resp_exccode.value = 0
        self.bus.mem_result_valid.value = 0
        self.bus.mem_result_id.value = 0
        self.bus.mem_result_rdata.value = 0
        self.bus.mem_result_err.value = 0

        self.bus.commit_valid.value = 0
        self.bus.commit_id.value = 0
        self.bus.commit_kill.value = 0
        self.bus.result_id.value = 0
        self.bus.result_ready.value = 1
        

        # self.bus.mem_resp_dbg.value = 0
        # self.bus.mem_result_dbg.value = 0
        # self.bus.compressed_valid.value = 0
        # self.bus.compressed_req.value = 0

        # self._run_coroutine_obj: Any = None
        # self._restart()

    def calc_instr(self, rd, rs1):
        """Build a BITREV instruction
        Format: funct7[31:25] | rs2[24:20] | rs1[19:15] | funct3[14:12] | rd[11:7] | opcode[6:0]
        BITREV: 0000010 | 00000 | rs1 | 111 | rd | 0101011
        """
        instr = 0
        instr |= 0x2B                # opcode [6:0] = 0101011
        instr |= (rd & 0x1F) << 7    # rd [11:7]
        instr |= 0x7 << 12           # funct3 [14:12] = 111
        instr |= (rs1 & 0x1F) << 15  # rs1 [19:15]
        instr |= 0x0 << 20           # rs2 [24:20] = 00000 (unused)
        instr |= 0x02 << 25          # funct7 [31:25] = 0000010
        return instr

    def calc_result(self, rs0: int, rs1: int, expected_val: int=-1) -> int:
        return expected_val
        
    async def commit(self, id: int, wait_cycle: int = 1, kill: int = 0):
        for i in range(wait_cycle):
            await RisingEdge(self.clock)
        self.bus.commit_valid.value = 1
        self.bus.commit_id.value = id
        self.bus.commit_kill.value = kill
        await RisingEdge(self.clock)
        self.bus.commit_valid.value = 0
        self.bus.commit_id.value = 0
        self.bus.commit_kill.value = 0

    async def result(self, id: int, expected_val: int=-1):
        # Wait for result
        timeout = 0
        while int(self.bus.result_valid.value) != 1 and timeout < self.timeout_max:
            await RisingEdge(self.clock)
            timeout += 1
        
        if timeout >= self.timeout_max:
            raise Exception("Timeout waiting for result")

        # Check result
        result_id = int(self.bus.result_id.value)
        result_data = int(self.bus.result_data.value)
        result_we = int(self.bus.result_we.value)

        # self.log.debug(f"Result ID: {result_id}, WE: {result_we}")
        self.log.debug(f"Result: 0x{result_data:08X}")
        # self.log.debug(f"Expected: 0x{expected_val:08X}")

        self.log.debug(f"Calculated: 0x{expected_val:08X}")
        if result_id != id:
            raise Exception(f"Result ID mismatch: got {result_id}, expected {id}")
        if expected_val != -1 and result_data != expected_val:
            raise Exception(f"Result data mismatch: got 0x{result_data:08X}, expected 0x{expected_val:08X}")
        if result_we != 1:
            raise Exception("Write enable not set")

    
    async def write_xx(
        self,
        rs0: int = 0,
        rs1: int = 0,
        expected_val: int = -1,
        mode: XifMode = XifMode.MMODE,
    ):
        x = self.calc_result(rs0, rs1, expected_val)
        id = self.tx_id

        instr = self.calc_instr()
        mode = XifMode.MMODE
        self.bus.issue_valid.value = 1        
        self.bus.issue_req_instr.value = instr
        self.bus.issue_req_mode.value = mode
        self.bus.issue_req_id.value = id
        self.bus.issue_req_rs_0.value = rs0
        self.bus.issue_req_rs_1.value = rs1
        self.bus.issue_req_rs_valid.value = 1
        start_soon(self.commit(id, wait_cycle=1))

        await ReadOnly()
        comb_accept = int(self.bus.issue_resp_accept.value)
        # if comb_accept:
        #     if int(self.bus.mem_req_id.value) != id:
        #         raise Exception(f"Combinatorial mem_req_id mismatch: got {int(self.bus.mem_req_id.value)}, expected {id}")
        #     if int(self.bus.issue_req_mode.value) != mode:
        #         raise Exception(f"Combinatorial issue_req_mode mismatch: got {int(self.bus.issue_req_mode.value)}, expected {XifMode.MMODE}")
        #comb_mem_req_id = int(self.bus.mem_req_id.value)
        #self.log.info(f"Combinatorial issue_resp_accept {int(self.bus.issue_resp_accept.value)}")
        await RisingEdge(self.clock)
        timeout = 0
        while int(self.bus.issue_ready.value) != 1 and timeout < self.timeout_max:
            await RisingEdge(self.clock)
            timeout += 1
        
        # Capture if accepted
        accepted = int(self.bus.issue_resp_accept.value)
        
        self.bus.issue_valid.value = 0
        self.bus.issue_req_instr.value = 0
        self.bus.issue_req_mode.value = mode
        self.bus.issue_req_id.value = 0
        self.bus.issue_req_rs_0.value = 0
        self.bus.issue_req_rs_1.value = 0
        self.bus.issue_req_rs_valid.value = 0
        # self.bus.issue_req_ecs.value = 0
        # self.bus.issue_req_ecs_valid.value = 0
        
        if not accepted:
            raise Exception("Instruction not accepted!")
        if not comb_accept:
            self.log.warning("Instruction not accepted (combinatorial)")
        # if int(self.bus.mem_req_id.value) != id:
        #     raise Exception(f"mem_req_id mismatch: got {int(self.bus.mem_req_id.value)}, expected {id}")
        # if int(self.bus.mem_req_mode.value) != mode:
        #     raise Exception(f"mem_req_mode mismatch: got {int(self.bus.mem_req_mode.value)}, expected {mode}")
        self.log.debug("Instruction accepted")
        
        self.tx_id = (id + 1) & self.id_mask
        # # Acknowledge result
        start_soon(self.result(id, expected_val=x))
        await RisingEdge(self.clock)
        await RisingEdge(self.clock)


    # async def write(
    #     self,
    #     addr: int,
    #     data: Union[int, bytes],
    #     strb: int = -1,
    #     prot: XifProt = XifProt.NONSECURE,
    #     error_expected: bool = False,
    #     device: int = 0,
    #     length: int = -1,
    #     index: int = -1,
    # ) -> None:
    #     self.write_nowait(addr, data, strb, prot, error_expected, device, length, index)
    #     await self._idle.wait()
    #     for i in range(self.intra_delay):
    #         await RisingEdge(self.clock)

    # def write_nowait(
    #     self,
    #     addr: int,
    #     data: Union[int, bytes],
    #     strb: int = -1,
    #     prot: XifProt = XifProt.NONSECURE,
    #     error_expected: bool = False,
    #     device: int = 0,
    #     length: int = -1,
    #     index: int = -1,
    # ) -> None:
    #     """ """
    #     self._idle.clear()
    #     self.addr = self.calc_address(addr, device, index)
    #     self.loop = self.calc_length(length, data)
    #     for i in range(self.loop):
    #         addrb = self.addr + i * self.wbytes
    #         if isinstance(data, int):
    #             subdata = (data >> self.wwidth * i) & self.wdata_mask
    #             datab = subdata.to_bytes(self.wbytes, "little")
    #         else:
    #             datab = data[i * self.wbytes : (i + 1) * self.wbytes]
    #         self.tx_id += 1
    #         self.queue_tx.append(
    #             (True, addrb, datab, strb, prot, error_expected, device, self.tx_id)
    #         )

    # async def poll(
    #     self,
    #     addr: int,
    #     data: Union[int, bytes] = bytes(),
    #     device: int = 0,
    #     index: int = -1,
    # ) -> None:
    #     self.addr = self.calc_address(addr, device, index)
    #     self.log.info(f"Poll  0x{self.addr:08x}")
    #     level_num = self.log.getEffectiveLevel()
    #     self.log.setLevel(logging.WARNING)
    #     if isinstance(data, int):
    #         datab = data.to_bytes(self.rbytes[device], "little")
    #     else:
    #         datab = data
    #     self.ret = None
    #     while not self.ret == datab:
    #         await self.read(addr, device=device)
    #     self.log.setLevel(level_num)

    # async def read(
    #     self,
    #     addr: int,
    #     data: Union[int, bytes] = bytes(),
    #     prot: XifProt = XifProt.NONSECURE,
    #     error_expected: bool = False,
    #     device: int = 0,
    #     index: int = -1,
    #     length: int = -1,
    # ) -> Union[bytes, int]:
    #     rx_id = self.read_nowait(
    #         addr, data, prot, error_expected, device, index, length
    #     )
    #     found = False
    #     while not found:
    #         while self.queue_rx:
    #             ret, tx_id = self.queue_rx.popleft()
    #             if rx_id == tx_id:
    #                 found = True
    #                 break
    #         await self._idle.wait()
    #     for i in range(self.intra_delay):
    #         await RisingEdge(self.clock)
    #     self.ret = ret
    #     if self.return_int:
    #         return int.from_bytes(ret, byteorder="little")
    #     else:
    #         return ret

    # def read_nowait(
    #     self,
    #     addr: int,
    #     data: Union[int, bytes] = bytes(),
    #     prot: XifProt = XifProt.NONSECURE,
    #     error_expected: bool = False,
    #     device: int = 0,
    #     index: int = -1,
    #     length: int = -1,
    # ) -> int:
    #     self._idle.clear()
    #     self.addr = self.calc_address(addr, device, index)
    #     self.loop = self.calc_length(length, data)
    #     for i in range(self.loop):
    #         addrb = self.addr + i * self.rbytes[device]
    #         if isinstance(data, int):
    #             subdata = (data >> self.rwidth[device] * i) & self.rdata_mask[device]
    #             datab = subdata.to_bytes(self.rbytes[device], "little")
    #         else:
    #             datab = data
    #         self.tx_id += 1
    #         self.queue_tx.append(
    #             (False, addrb, datab, -1, prot, error_expected, device, self.tx_id)
    #         )
    #     return self.tx_id

    def _restart(self) -> None:
        if self._run_coroutine_obj is not None:
            self._run_coroutine_obj.kill()
        self._run_coroutine_obj = start_soon(self._run())

    @property
    def count_tx(self) -> int:
        return len(self.queue_tx)

    @property
    def empty_tx(self) -> bool:
        return not self.queue_tx

    @property
    def count_rx(self) -> int:
        return len(self.queue_rx)

    @property
    def empty_rx(self) -> bool:
        return not self.queue_rx

    @property
    def idle(self) -> bool:
        return self.empty_tx and self.empty_rx

    def clear(self) -> None:
        """Clears the RX and TX queues"""
        self.queue_tx.clear()
        self.queue_rx.clear()

    async def wait(self) -> None:
        """Wait for idle"""
        await self._idle.wait()

    # async def _run(self):
    #     while True:
    #         if not self.queue_tx:
    #             await RisingEdge(self.clock)
    #         else:
    #             (
    #                 write,
    #                 addr,
    #                 data,
    #                 strb,
    #                 prot,
    #                 error_expected,
    #                 device,
    #                 tx_id,
    #             ) = self.queue_tx.popleft()

    #             if addr < 0 or addr >= 2**self.address_width:
    #                 raise ValueError("Address out of range")

    #             if device > len(self.bus.psel) - 1:
    #                 raise ValueError(
    #                     f"Trying to access a device, {device}, that is not available on the bus {len(self.bus.psel)-1}"
    #                 )

    #             self.bus.psel.value = 1 << device
    #             self.bus.paddr.value = addr
    #             extra_text = ""
    #             if self.pprot_present:
    #                 self.bus.pprot.value = prot
    #                 extra_text += f" prot: {prot}"
    #             apb = ""
    #             if self.multi_device:
    #                 apb = f"({device}) "
    #             if self.penable_present:
    #                 self.bus.penable.value = 0
    #             if write:
    #                 data = int.from_bytes(data, byteorder="little")
    #                 self.log.info(f"Write {apb}0x{addr:08x}: 0x{data:08x}{extra_text}")
    #                 self.bus.pwdata.value = data & self.wdata_mask
    #                 self.bus.pwrite.value = 1
    #                 if self.pstrb_present:
    #                     if -1 == strb:
    #                         self.bus.pstrb.value = self.strb_mask
    #                     else:
    #                         self.bus.pstrb.value = strb

    #             await RisingEdge(self.clock)
    #             if self.penable_present:
    #                 self.bus.penable.value = 1
    #                 await FallingEdge(self.clock)
    #             timeout = 0
    #             while not self.bus.pready.value:
    #                 await FallingEdge(self.clock)
    #                 if self.timeout_max != -1:
    #                     timeout += 1
    #                     if timeout >= self.timeout_max:
    #                         self.log.info(f"Read  {apb}0x{addr:08x}:{extra_text}")
    #                         raise TimeoutError(
    #                             f"XIF transaction timeout: pready not asserted within {self.timeout_max} clock cycles (addr: 0x{addr:08x})"
    #                         )

    #             if self.pslverr_present:
    #                 if not bool(self.bus.pslverr.value) == error_expected:
    #                     if bool(self.bus.pslverr.value):
    #                         msg = "PSLVERR detected not expected!"
    #                     else:
    #                         msg = "PSLVERR expected not detected!"
    #                     if self.pprot_present:
    #                         msg += f" PPROT - {XifProt(self.bus.pprot.value).name}"
    #                     self.exception_occurred = True
    #                     if self.exception_enabled:
    #                         self.log.critical(msg)
    #                         raise Exception(msg)
    #                     else:
    #                         self.log.warning(msg)

    #             if not write:
    #                 ret = resolve_x_int(self.bus.prdata)
    #                 ret_slice = (
    #                     ret >> (device * self.rwidth[device])
    #                 ) & self.rdata_mask[device]
    #                 self.log.info(
    #                     f"Read  {apb}0x{addr:08x}: 0x{ret_slice:08x}{extra_text}"
    #                 )
    #                 if not data == bytes():
    #                     data_int = int.from_bytes(data, byteorder="little")
    #                     if not data_int == ret_slice:
    #                         self.bus.psel.value = 0
    #                         await RisingEdge(self.clock)
    #                         await RisingEdge(self.clock)
    #                         await RisingEdge(self.clock)
    #                         raise Exception(
    #                             f"Expected 0x{data_int:08x} doesn't match returned 0x{ret_slice:08x}"
    #                         )
    #                 self.queue_rx.append(
    #                     (ret_slice.to_bytes(self.rbytes[device], "little"), tx_id)
    #                 )

    #             if not self.queue_tx:
    #                 self._idle.set()

    #             await RisingEdge(self.clock)

    #             if self.penable_present:
    #                 self.bus.penable.value = 0
    #             self.bus.psel.value = 0
    #             self.bus.paddr.value = 0
    #             if self.pprot_present:
    #                 self.bus.pprot.value = 0
    #             self.bus.pwrite.value = 0
    #             self.bus.pwdata.value = 0
    #             if self.pstrb_present:
    #                 self.bus.pstrb.value = 0


class XifMaster(XifHost):
    """Deprecated alias for XifHost."""

    pass
