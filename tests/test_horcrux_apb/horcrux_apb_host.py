"""APB register map and host driver for horcrux_apb_wrapper."""

from __future__ import annotations

import struct
from typing import Optional

from cocotb.triggers import RisingEdge, Timer

from cocotbext.apb import ApbBus, ApbMaster

REG_RS1 = 0x00
REG_RS2 = 0x04
REG_RS3 = 0x08
REG_CMD = 0x0C
REG_INSTR = 0x10
REG_STATUS = 0x14
REG_RD1 = 0x18

STATUS_BUSY = 1 << 0
STATUS_DONE = 1 << 1
STATUS_ACCEPT = 1 << 2


def _u32_bytes(value: int) -> bytes:
    return struct.pack("<I", value & 0xFFFFFFFF)


def _bytes_u32(data: bytes) -> int:
    return struct.unpack("<I", data)[0]


class HorcruxApbHost:
    """Drive HORCRUX operations through the PeakRDL-etana APB register block."""

    def __init__(self, bus: ApbBus, clock, timeout_max: int = 200_000):
        self.bus = bus
        self.clock = clock
        self.timeout_max = timeout_max
        self.master = ApbMaster(bus, clock)

    async def write_reg(self, offset: int, value: int) -> None:
        await self.master.write(offset, _u32_bytes(value))

    async def read_reg(self, offset: int) -> int:
        data = await self.master.read(offset)
        return _bytes_u32(data)

    async def read_status(self) -> int:
        return await self.read_reg(REG_STATUS)

    async def clear_done(self) -> None:
        await self.write_reg(REG_STATUS, STATUS_DONE)

    async def wait_done(self) -> None:
        for _ in range(self.timeout_max):
            status = await self.read_status()
            if status & STATUS_DONE:
                return
            await RisingEdge(self.clock)
        raise TimeoutError("HORCRUX APB operation timed out waiting for STATUS.DONE")

    async def wait_idle(self) -> None:
        for _ in range(self.timeout_max):
            status = await self.read_status()
            if not (status & STATUS_BUSY):
                return
            await RisingEdge(self.clock)
        raise TimeoutError("HORCRUX APB timed out waiting for idle")

    async def execute_cmd(
        self,
        opcode: int,
        rs1: int = 0,
        rs2: int = 0,
        rs3: int = 0,
        *,
        expected: Optional[int] = None,
    ) -> int:
        await self.wait_idle()
        await self.clear_done()
        await self.write_reg(REG_RS1, rs1)
        await self.write_reg(REG_RS2, rs2)
        await self.write_reg(REG_RS3, rs3)
        await self.write_reg(REG_CMD, opcode & 0x7F)
        await self.wait_done()
        result = await self.read_reg(REG_RD1)
        if expected is not None and (result & 0xFFFFFFFF) != (expected & 0xFFFFFFFF):
            raise RuntimeError(
                f"HORCRUX CMD result mismatch: got 0x{result:08x}, "
                f"expected 0x{expected & 0xFFFFFFFF:08x}"
            )
        return result & 0xFFFFFFFF

    async def execute_instr(
        self,
        instr: int,
        rs1: int = 0,
        rs2: int = 0,
        rs3: int = 0,
        *,
        expected: Optional[int] = None,
    ) -> int:
        await self.wait_idle()
        await self.clear_done()
        await self.write_reg(REG_RS1, rs1)
        await self.write_reg(REG_RS2, rs2)
        await self.write_reg(REG_RS3, rs3)
        await self.write_reg(REG_INSTR, instr & 0xFFFFFFFF)
        await self.wait_done()
        result = await self.read_reg(REG_RD1)
        if expected is not None and (result & 0xFFFFFFFF) != (expected & 0xFFFFFFFF):
            raise RuntimeError(
                f"HORCRUX INSTR result mismatch: got 0x{result:08x}, "
                f"expected 0x{expected & 0xFFFFFFFF:08x}"
            )
        return result & 0xFFFFFFFF

    async def issue_instr(
        self,
        instr: int,
        rs1: int = 0,
        rs2: int = 0,
        rs3: int = 0,
    ) -> None:
        """Issue an instruction without waiting for completion (Keccak-style)."""
        await self.wait_idle()
        await self.write_reg(REG_RS1, rs1)
        await self.write_reg(REG_RS2, rs2)
        await self.write_reg(REG_RS3, rs3)
        await self.write_reg(REG_INSTR, instr & 0xFFFFFFFF)

    async def execute(
        self,
        instr: int,
        rs=(0, 0, 0),
        *,
        expected: Optional[int] = None,
        rs_valid: int = 0b11,
    ) -> int:
        rs0 = rs[0] if rs_valid & 0b001 else 0
        rs1 = rs[1] if rs_valid & 0b010 else 0
        rs2 = rs[2] if rs_valid & 0b100 else 0
        return await self.execute_instr(
            instr, rs0, rs1, rs2, expected=expected
        )

    async def idle_cycles(self, n: int) -> None:
        for _ in range(n):
            await RisingEdge(self.clock)
