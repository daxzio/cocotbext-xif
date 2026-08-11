"""
Generic RISC-V instruction field packing.

These helpers encode instruction *fields* only. Opcode/funct tables belong with
each DUT's testbench (see ``encoders.py``).
"""


def encode_r(
    opcode: int,
    rd: int,
    funct3: int,
    rs1: int,
    rs2: int,
    funct7: int,
) -> int:
    """Pack a standard R-type instruction word."""
    instr = opcode & 0x7F
    instr |= (rd & 0x1F) << 7
    instr |= (funct3 & 0x7) << 12
    instr |= (rs1 & 0x1F) << 15
    instr |= (rs2 & 0x1F) << 20
    instr |= (funct7 & 0x7F) << 25
    return instr


def encode_r4(
    opcode: int,
    rd: int,
    funct3: int,
    rs1: int,
    rs2: int,
    rs3: int,
    funct2: int,
) -> int:
    """Pack an R4-type instruction word (opcode 0x6b family)."""
    instr = opcode & 0x7F
    instr |= (rd & 0x1F) << 7
    instr |= (funct3 & 0x7) << 12
    instr |= (rs1 & 0x1F) << 15
    instr |= (rs2 & 0x1F) << 20
    instr |= (funct2 & 0x3) << 25
    instr |= (rs3 & 0x1F) << 27
    return instr


def encode_i(
    opcode: int,
    rd: int,
    funct3: int,
    rs1: int,
    imm: int,
) -> int:
    """Pack an I-type instruction word."""
    imm12 = imm & 0xFFF
    instr = opcode & 0x7F
    instr |= (rd & 0x1F) << 7
    instr |= (funct3 & 0x7) << 12
    instr |= (rs1 & 0x1F) << 15
    instr |= imm12 << 20
    return instr
