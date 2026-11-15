"""HORCRUX custom instruction encodings (from horcrux_pkg / sw/applications/tests)."""

OP_CUSTOM_R = 0x3B
OP_CUSTOM_R4 = 0x6B
FUNCT3 = 7


def build_r_insn(funct7, rd=10, rs1=5, rs2=6, opcode=OP_CUSTOM_R):
    """Build R-type custom instruction (opcode 0x3b)."""
    instr = opcode & 0x7F
    instr |= (rd & 0x1F) << 7
    instr |= (FUNCT3 & 0x7) << 12
    instr |= (rs1 & 0x1F) << 15
    instr |= (rs2 & 0x1F) << 20
    instr |= (funct7 & 0x7F) << 25
    return instr


def build_r4_insn(funct2, rd=0, rs1=0, rs2=0, rs3=0, funct3=FUNCT3, opcode=OP_CUSTOM_R4):
    """Build R4-type custom instruction (opcode 0x6b)."""
    instr = opcode & 0x7F
    instr |= (rd & 0x1F) << 7
    instr |= (funct3 & 0x7) << 12
    instr |= (rs1 & 0x1F) << 15
    instr |= (rs2 & 0x1F) << 20
    instr |= (funct2 & 0x3) << 25
    instr |= (rs3 & 0x1F) << 27
    return instr


# funct7 values used by Wave 1 tests (instruction word [31:25])
FUNCT7_MQMULK = 0x11
FUNCT7_MQMULD = 0x12
FUNCT7_MQMULF = 0x10
# Falcon scalar Montgomery reduce: OP_MQMULF with rs2=1 (upstream falcon-montg
# still emits funct7=0x02/OP_STORE, which no longer matches current RTL).
FUNCT7_MONTG_FALCON = FUNCT7_MQMULF
FUNCT7_BARRETT_KYBER = 0x05
FUNCT7_BARRETT_HQC1 = 0x58
FUNCT7_BARRETT_HQC3 = 0x59
FUNCT7_BARRETT_HQC5 = 0x5A
FUNCT7_RED32 = 0x1A
FUNCT7_COMPARE_U32 = 0x79
FUNCT7_GFMUL8 = 0x16
FUNCT7_GFREDUCE = 0x78

# Keccak / state (Wave 2)
FUNCT7_KINIT = 0x0E
FUNCT7_KSTORE = 0x0F
FUNCT7_KABSORB = 0x01  # funct2 for 0x6b
FUNCT7_KSTART = 0x00   # funct2 for 0x6b
FUNCT7_KPERM = 0x02    # funct2 for 0x6b
FUNCT3_KECCAK = 1

# NTT butterfly (R4, funct3=7)
FUNCT2_BFNTTK = 0
FUNCT2_BFINTTK = 1
FUNCT2_BFNTTD = 2
FUNCT2_BFINTTD = 3
FUNCT7_BFNTTDH = 0x17
FUNCT7_BFINTTDH = 0x18

# Karatsuba (HQC 64x64)
FUNCT7_KARATS_1 = 0x13
FUNCT7_KARATS_2 = 0x14
FUNCT7_KARATS_3 = 0x15
FUNCT7_KARATS_4 = 0x19

# SPHINCS+ / CBD (Wave 7+)
FUNCT7_CBD1 = 0x00
FUNCT7_CBD2 = 0x01
FUNCT7_CBD3 = 0x02
FUNCT7_CBD4 = 0x03
FUNCT7_REJ_UNIFORM = 0x48
FUNCT7_REJ_ETA2 = 0x49
FUNCT7_REJ_ETA4 = 0x4A
FUNCT7_UNPACK_Z = 0x4B
FUNCT7_FPR_LOAD_SE = 0x33
FUNCT7_FPR_LOAD_M = 0x34
FUNCT7_FPR_RDHI = 0x35
FUNCT7_FPR_NORM64_RDHI = 0x36
FUNCT7_FPR_NORM64_EXEC = 0x37
FUNCT3_FALCON_BF = 6
FUNCT2_BFNTTF = 0
FUNCT2_BFINTTF = 1
FUNCT2_FPR_NORM64 = 3
FUNCT7_THASH1 = 0x30
FUNCT7_THASH2 = 0x31
FUNCT7_PRF_ADDR = 0x32
FUNCT7_THASH1_192 = 0x3C
FUNCT7_THASH2_192 = 0x3D
FUNCT7_THASH1_256 = 0x3E
FUNCT7_THASH2_256 = 0x3F
FUNCT7_PRF_192 = 0x40
FUNCT7_PRF_256 = 0x41
FUNCT7_CL_128F = 0x1B
FUNCT7_CL_192F = 0x1C
FUNCT7_CL_256F = 0x1D
FUNCT2_LOAD = 0x03
FUNCT3_LOAD = 0x01
