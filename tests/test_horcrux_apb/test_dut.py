"""
CocoTB tests for HORCRUX over APB (PeakRDL-etana register front-end).

Reuses vector tables and encoders from tests/test_horcrux.
"""

import struct

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from cocotbext.apb import ApbBus
from cocotbext.xif import HorcruxEncoder

from horcrux_apb_host import HorcruxApbHost
from horcrux_opcodes import (
    OP_BARRETT,
    OP_COMPARE_U32,
    OP_MQMULK,
    OP_RED32,
)
from horcrux_encodings import (
    FUNCT2_LOAD,
    FUNCT3_KECCAK,
    FUNCT3_LOAD,
    FUNCT7_BARRETT_HQC1,
    FUNCT7_BARRETT_HQC3,
    FUNCT7_BARRETT_HQC5,
    FUNCT7_BARRETT_KYBER,
    FUNCT7_COMPARE_U32,
    FUNCT7_GFMUL8,
    FUNCT7_GFREDUCE,
    FUNCT7_KABSORB,
    FUNCT7_KARATS_1,
    FUNCT7_KARATS_2,
    FUNCT7_KARATS_3,
    FUNCT7_KARATS_4,
    FUNCT7_KINIT,
    FUNCT7_KPERM,
    FUNCT7_KSTORE,
    FUNCT7_MQMULD,
    FUNCT7_MQMULF,
    FUNCT7_MQMULK,
    FUNCT7_RED32,
)
from vectors import (
    COMPARE_U32_TESTS,
    DILITHIUM_MONTG_TESTS,
    DILITHIUM_REDUCE32_TESTS,
    FQMUL_TESTS,
    GF_REDUCE_TESTS,
    HQC_BARRETT_HQC1_TESTS,
    HQC_BARRETT_HQC3_TESTS,
    HQC_BARRETT_HQC5_TESTS,
    KARATS_TESTS,
    KYBER_BARRETT_TESTS,
    KYBER_MONTG_TESTS,
    MQ_MONTYMUL_TESTS,
    SHA3_256_ABC_EXPECTED,
)
from vectors_chain_lengths import CHAIN_LENGTHS_VECTORS
from vectors_gf_carryless import GF_CARRYLESS_TESTS


async def _reset_dut(dut, cycles=10):
    dut.rst_ni.value = 0
    for _ in range(cycles):
        await RisingEdge(dut.clk_i)
    dut.rst_ni.value = 1
    for _ in range(5):
        await RisingEdge(dut.clk_i)


async def _setup(dut, timeout_max=500_000):
    clock = Clock(dut.clk_i, 10, unit="ns")
    cocotb.start_soon(clock.start())
    await _reset_dut(dut)
    apb_bus = ApbBus.from_prefix(dut, "s_apb")
    host = HorcruxApbHost(apb_bus, dut.clk_i, timeout_max=timeout_max)
    return host, HorcruxEncoder()


async def _run_vector_table(
    dut,
    instr,
    vectors,
    rs0_idx=0,
    rs1_idx=1,
    rs2_idx=2,
    exp_idx=2,
    rs1_default=0,
):
    host, _enc = await _setup(dut)
    for row in vectors:
        rs0 = row[rs0_idx]
        if len(row) > rs1_idx and rs1_idx != exp_idx:
            rs1 = row[rs1_idx]
        else:
            rs1 = rs1_default
        expected = row[exp_idx]
        await host.execute(
            instr,
            rs=(rs0 & 0xFFFFFFFF, rs1 & 0xFFFFFFFF),
            expected=expected & 0xFFFFFFFF,
        )


def _msg_words(msg: bytes) -> list[int]:
    words = []
    for i in range(0, len(msg), 4):
        chunk = msg[i : i + 4]
        words.append(struct.unpack("<I", chunk.ljust(4, b"\x00"))[0])
    return words


def _unpack_nibbles(words: list[int]) -> list[int]:
    out = []
    for word in words:
        for shift in (28, 24, 20, 16, 12, 8, 4, 0):
            out.append((word >> shift) & 0xF)
    return out


async def _karats_hw(host, enc, a: int, b: int) -> tuple[int, int]:
    a_lo = a & 0xFFFFFFFF
    a_hi = (a >> 32) & 0xFFFFFFFF
    b_lo = b & 0xFFFFFFFF
    b_hi = (b >> 32) & 0xFFFFFFFF

    out1 = await host.execute(enc.encode_r(FUNCT7_KARATS_1), rs=(a_lo, b_lo))
    out2 = await host.execute(enc.encode_r(FUNCT7_KARATS_2), rs=(a_hi, b_hi))
    out3 = await host.execute(enc.encode_r(FUNCT7_KARATS_3), rs=(a_lo, b_lo))
    out4 = await host.execute(enc.encode_r(FUNCT7_KARATS_4))

    c0 = (out1 & 0xFFFFFFFF) | ((out3 & 0xFFFFFFFF) << 32)
    c1 = (out4 & 0xFFFFFFFF) | ((out2 & 0xFFFFFFFF) << 32)
    return c0, c1


async def _chain_lengths_hw(host, enc, vector: dict) -> list[int]:
    msg_words = _msg_words(vector["msg"])
    load_instr = enc.encode_r4(FUNCT2_LOAD, funct3=FUNCT3_LOAD)
    compute_instr = enc.encode_r(vector["cl_funct7"])
    store_instr = enc.encode_r(FUNCT7_KSTORE, rd=10, rs1=0, rs2=0)

    for load_idx in range(0, vector["nwords"], 2):
        lo = msg_words[load_idx]
        hi = msg_words[load_idx + 1]
        await host.execute(load_instr, rs=(lo, hi, load_idx), rs_valid=0b111)
        await host.idle_cycles(10)

    await host.execute(compute_instr)
    await host.idle_cycles(100)

    words = []
    for store_idx in range(vector["nstores"]):
        result = await host.execute(store_instr, rs=(store_idx, 0, 0))
        words.append(result & 0xFFFFFFFF)

    return _unpack_nibbles(words)[: len(vector["expected"])]


@cocotb.test()
async def test_fqmul(dut):
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_MQMULK)
    for a, b, expected in FQMUL_TESTS:
        await host.execute(instr, rs=(a, b), expected=expected)


@cocotb.test()
async def test_kyber_montg(dut):
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_MQMULK)
    vectors = [(a, 1, e) for a, e in KYBER_MONTG_TESTS]
    await _run_vector_table(dut, instr, vectors)


@cocotb.test()
async def test_dilithium_montg(dut):
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_MQMULD)
    vectors = [(a, 1, e) for a, e in DILITHIUM_MONTG_TESTS]
    await _run_vector_table(dut, instr, vectors)


@cocotb.test()
async def test_kyber_barrett(dut):
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_BARRETT_KYBER)
    vectors = [(a, 1, e) for a, e in KYBER_BARRETT_TESTS]
    await _run_vector_table(dut, instr, vectors)


@cocotb.test()
async def test_hqc_barrett_hqc1(dut):
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_BARRETT_HQC1)
    vectors = [(a, 0, e) for a, e in HQC_BARRETT_HQC1_TESTS]
    await _run_vector_table(dut, instr, vectors, exp_idx=2)


@cocotb.test()
async def test_hqc_barrett_hqc3(dut):
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_BARRETT_HQC3)
    vectors = [(a, 0, e) for a, e in HQC_BARRETT_HQC3_TESTS]
    await _run_vector_table(dut, instr, vectors, exp_idx=2)


@cocotb.test()
async def test_hqc_barrett_hqc5(dut):
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_BARRETT_HQC5)
    vectors = [(a, 0, e) for a, e in HQC_BARRETT_HQC5_TESTS]
    await _run_vector_table(dut, instr, vectors, exp_idx=2)


@cocotb.test()
async def test_gf_carryless(dut):
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_GFMUL8)
    for a, b, c0, c1 in GF_CARRYLESS_TESTS:
        expected = (c1 << 8) | c0
        await host.execute(instr, rs=(a, b), expected=expected)


@cocotb.test()
async def test_gf_reduce(dut):
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_GFREDUCE)
    vectors = [(a, 0, e) for a, e in GF_REDUCE_TESTS]
    await _run_vector_table(dut, instr, vectors, exp_idx=2)


@cocotb.test()
async def test_dilithium_reduce32(dut):
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_RED32)
    for a, expected in DILITHIUM_REDUCE32_TESTS:
        await host.execute(instr, rs=(a, 0), expected=expected)


@cocotb.test()
async def test_compare_u32(dut):
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_COMPARE_U32)
    for a, b, expected in COMPARE_U32_TESTS:
        await host.execute(instr, rs=(a, b), expected=expected)


@cocotb.test()
async def test_mq_montymul(dut):
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_MQMULF)
    for a, b, expected in MQ_MONTYMUL_TESTS:
        await host.execute(instr, rs=(a, b), expected=expected)


@cocotb.test()
async def test_karats(dut):
    host, enc = await _setup(dut, timeout_max=200_000)
    for a, b, exp_c0, exp_c1 in KARATS_TESTS:
        got_c0, got_c1 = await _karats_hw(host, enc, a, b)
        if got_c0 != exp_c0 or got_c1 != exp_c1:
            raise RuntimeError(
                f"karats mismatch: a={a} b={b} "
                f"got=({got_c0}, {got_c1}) expected=({exp_c0}, {exp_c1})"
            )


@cocotb.test()
async def test_chain_lengths(dut):
    host, enc = await _setup(dut, timeout_max=300_000)
    for vector in CHAIN_LENGTHS_VECTORS:
        got = await _chain_lengths_hw(host, enc, vector)
        if got != vector["expected"]:
            raise RuntimeError(
                f"chain_lengths {vector['name']} mismatch: "
                f"got {got}, expected {vector['expected']}"
            )


@cocotb.test()
async def test_keccak_sha3_256_abc(dut):
    host, enc = await _setup(dut, timeout_max=2_000_000)

    init_instr = enc.encode_r(FUNCT7_KINIT)
    await host.issue_instr(init_instr)
    await host.idle_cycles(50)

    msg = b"abc"
    rate_words = 136 // 4
    xor_buf = [0] * rate_words
    for i, byte in enumerate(msg):
        xor_buf[i // 4] |= byte << (8 * (i % 4))
    xor_buf[len(msg) // 4] |= 0x06 << (8 * (len(msg) % 4))
    xor_buf[rate_words - 1] |= 0x80000000

    absorb_instr = enc.encode_r4(FUNCT7_KABSORB, funct3=FUNCT3_KECCAK)
    for i in range(0, rate_words, 2):
        lo = xor_buf[i]
        hi = xor_buf[i + 1]
        if lo | hi:
            await host.issue_instr(absorb_instr, rs1=lo, rs2=hi, rs3=i)
            await host.idle_cycles(20)

    perm_instr = enc.encode_r4(FUNCT7_KPERM, funct3=FUNCT3_KECCAK)
    await host.issue_instr(perm_instr, rs1=1)
    await host.idle_cycles(500)

    store_instr = enc.encode_r(FUNCT7_KSTORE, rd=10, rs1=0, rs2=0)
    digest = bytearray()
    for word_idx in range(8):
        expected = struct.unpack(
            "<I", SHA3_256_ABC_EXPECTED[word_idx * 4 : (word_idx + 1) * 4]
        )[0]
        await host.execute(store_instr, rs=(word_idx, 0, 0), expected=expected)
        digest.extend(SHA3_256_ABC_EXPECTED[word_idx * 4 : (word_idx + 1) * 4])

    if bytes(digest) != SHA3_256_ABC_EXPECTED:
        raise RuntimeError(
            f"SHA3-256 mismatch: got {digest.hex()}, "
            f"expected {SHA3_256_ABC_EXPECTED.hex()}"
        )


@cocotb.test()
async def test_cmd_vs_instr_equivalence(dut):
    """Direct CMD.OPCODE and INSTR alias must produce identical results."""
    host, enc = await _setup(dut)
    cases = [
        (OP_MQMULK, enc.encode_r(FUNCT7_MQMULK), 0x12345678, 0x9ABCDEF0),
        (OP_BARRETT, enc.encode_r(FUNCT7_BARRETT_KYBER), 0x01234567, 0x89ABCDEF),
        (OP_COMPARE_U32, enc.encode_r(FUNCT7_COMPARE_U32), 5, 9),
        (OP_RED32, enc.encode_r(FUNCT7_RED32), 0xDFFFFFF0, 0),
    ]
    for opcode, instr, rs1, rs2 in cases:
        ref = await host.execute_instr(instr, rs1=rs1, rs2=rs2)
        cmd = await host.execute_cmd(opcode, rs1=rs1, rs2=rs2)
        if cmd != ref:
            raise RuntimeError(
                f"CMD/INSTR mismatch for opcode 0x{opcode:02x}: "
                f"cmd=0x{cmd:08x} instr=0x{ref:08x}"
            )
