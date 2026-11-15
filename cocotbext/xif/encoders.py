"""
DUT-specific instruction encoders and reference models.

These classes are staged in the library for convenience during bring-up. The
intended long-term home is each coprocessor's cocotb testbench directory.
"""

from __future__ import annotations

import struct
from abc import ABC, abstractmethod
from collections.abc import Sequence
from typing import Any

from .riscv import encode_r, encode_r4


class InsnEncoder(ABC):
    """Build instruction words and optional software reference models."""

    @abstractmethod
    def encode(self, **kwargs: Any) -> int:
        """Return a 32-bit instruction word."""

    def model(self, rs: Sequence[int], **kwargs: Any) -> int | None:
        """Optional reference result for ``rs`` operand values."""
        return None


class BitrevEncoder(InsnEncoder):
    """BITREV custom instruction (test_xif_copro)."""

    def encode(self, rd: int = 10, rs1: int = 5, **_kwargs: Any) -> int:
        return encode_r(opcode=0x2B, rd=rd, funct3=0x7, rs1=rs1, rs2=0, funct7=0x02)

    def model(self, rs: Sequence[int], **_kwargs: Any) -> int:
        return int(f"{rs[0] & 0xFFFFFFFF:032b}"[::-1], 2)


class FaddSEncoder(InsnEncoder):
    """FADD.S (test_fpu_ss)."""

    def encode(
        self, rd: int = 10, rs1: int = 5, rs2: int = 6, rm: int = 0, **_kwargs: Any
    ) -> int:
        return encode_r(opcode=0x53, rd=rd, funct3=rm & 0x7, rs1=rs1, rs2=rs2, funct7=0)

    def model(self, rs: Sequence[int], **_kwargs: Any) -> int:
        f_a = struct.unpack("f", struct.pack("I", rs[0] & 0xFFFFFFFF))[0]
        f_b = struct.unpack("f", struct.pack("I", rs[1] & 0xFFFFFFFF))[0]
        return struct.unpack("I", struct.pack("f", f_a + f_b))[0]


def vtype_encode(sew: int, lmul: int, ta: int = 1, ma: int = 1) -> int:
    """Encode vtype immediate: sew[2:0], lmul[5:3], ta, ma."""
    return (sew & 0x7) | ((lmul & 0x7) << 3) | (ta << 6) | (ma << 7)


class RvvConfigEncoder(InsnEncoder):
    """RISC-V V extension vset* configuration instructions (test_ara)."""

    def encode_vsetvli(self, rd: int = 10, rs1: int = 5, vtypei: int = 0) -> int:
        instr = 0x57
        instr |= (rd & 0x1F) << 7
        instr |= 0x7 << 12
        instr |= (rs1 & 0x1F) << 15
        instr |= (vtypei & 0x7FF) << 20
        return instr

    def encode_vsetivli(self, rd: int = 10, uimm5: int = 0, vtypei: int = 0) -> int:
        instr = 0x57
        instr |= (rd & 0x1F) << 7
        instr |= 0x7 << 12
        instr |= (uimm5 & 0x1F) << 15
        instr |= (vtypei & 0x3FF) << 20
        instr |= 0x3 << 30
        return instr

    def encode_vsetvl(self, rd: int = 10, rs1: int = 5, rs2: int = 6) -> int:
        return encode_r(opcode=0x57, rd=rd, funct3=0x7, rs1=rs1, rs2=rs2, funct7=0x40)

    def encode(self, kind: str = "vsetvli", **kwargs: Any) -> int:
        if kind == "vsetivli":
            return self.encode_vsetivli(**kwargs)
        if kind == "vsetvl":
            return self.encode_vsetvl(**kwargs)
        return self.encode_vsetvli(**kwargs)


class HorcruxEncoder(InsnEncoder):
    """HORCRUX custom instructions (test_horcrux)."""

    OP_CUSTOM_R = 0x3B
    OP_CUSTOM_R4 = 0x6B
    FUNCT3 = 7

    def encode_r(self, funct7: int, rd: int = 10, rs1: int = 5, rs2: int = 6) -> int:
        return encode_r(
            opcode=self.OP_CUSTOM_R,
            rd=rd,
            funct3=self.FUNCT3,
            rs1=rs1,
            rs2=rs2,
            funct7=funct7,
        )

    def encode_r4(
        self,
        funct2: int,
        rd: int = 0,
        rs1: int = 0,
        rs2: int = 0,
        rs3: int = 0,
        funct3: int = FUNCT3,
    ) -> int:
        return encode_r4(
            opcode=self.OP_CUSTOM_R4,
            rd=rd,
            funct3=funct3,
            rs1=rs1,
            rs2=rs2,
            rs3=rs3,
            funct2=funct2,
        )

    def encode(self, funct7: int = 0, **_kwargs: Any) -> int:
        return self.encode_r(funct7, **_kwargs)
