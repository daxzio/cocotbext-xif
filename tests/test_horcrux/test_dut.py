"""
CocoTB tests for HORCRUX coprocessor over CV-X-IF.

Migration status vs ~/projects/horcrux/sw/applications/tests/run_tests.sh:
  Done:    fqmul, compare-u32, kyber/dilithium-montg, kyber-barrett,
           dilithium-reduce32, hqc-barrett (HQC-1/3/5), gf-carryless (101),
           gf-reduce, mq-montymul, karats, chain-lengths,
           keccak-abs (SHA3-256/512, SHAKE256, SHAKE128 multi-squeeze),
           kyber/dilithium-{ntt,intt}, kyber/dilithium-poly-{ntt,intt},
           cbd_eta{1,2,3,4}, thash1/2, prf-addr, thash-wots, gen-matrix,
           falcon-{ntt,intt,fpr,fpr-norm}, mldsa-{rej-uniform,rej-eta2,unpack-z}
  Skips:   see SKIPPED_TESTS.md (test_falcon_montg, test_mldsa_rej_eta4)
  Blocked: sampler-test (missing upstream directory; no cocotb test yet)
"""

import hashlib
import struct

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from cocotbext.xif import XifBus, XifHost, XifMonitor, HorcruxEncoder, XifMode

from xif_helpers import init_reset_before_host

from horcrux_encodings import (
    FUNCT2_BFINTTD,
    FUNCT2_BFINTTK,
    FUNCT2_BFNTTD,
    FUNCT2_BFNTTK,
    FUNCT2_LOAD,
    FUNCT3_KECCAK,
    FUNCT3_LOAD,
    FUNCT7_BARRETT_HQC1,
    FUNCT7_BARRETT_HQC3,
    FUNCT7_BARRETT_HQC5,
    FUNCT7_BARRETT_KYBER,
    FUNCT7_BFINTTDH,
    FUNCT7_BFNTTDH,
    FUNCT7_CBD1,
    FUNCT7_CBD2,
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
    FUNCT7_MONTG_FALCON,
    FUNCT7_MQMULD,
    FUNCT7_MQMULF,
    FUNCT7_MQMULK,
    FUNCT7_RED32,
    FUNCT7_THASH1,
    FUNCT7_THASH2,
    FUNCT7_PRF_ADDR,
)
from vectors import (
    COMPARE_U32_TESTS,
    DILITHIUM_MONTG_TESTS,
    DILITHIUM_REDUCE32_TESTS,
    FALCON_MONTG_TESTS,
    FQMUL_TESTS,
    GF_REDUCE_TESTS,
    HQC_BARRETT_HQC1_TESTS,
    HQC_BARRETT_HQC3_TESTS,
    HQC_BARRETT_HQC5_TESTS,
    KARATS_TESTS,
    KYBER_BARRETT_TESTS,
    KYBER_MONTG_TESTS,
    KYBER_NTT_BF_EXPECTED,
    KYBER_NTT_BF_INPUT,
    MQ_MONTYMUL_TESTS,
    SHA3_256_ABC_EXPECTED,
)
from vectors_chain_lengths import CHAIN_LENGTHS_VECTORS
from vectors_cbd_eta1 import CBD_ETA1_TESTS
from vectors_cbd_eta2 import CBD_ETA2_TESTS
from vectors_dilithium_intt import DILITHIUM_INTT_IN, DILITHIUM_INTT_OUT
from vectors_dilithium_ntt import DILITHIUM_NTT_IN, DILITHIUM_NTT_OUT, ZETAS_DSA
from vectors_gf_carryless import GF_CARRYLESS_TESTS
from vectors_gen_matrix import (
    GEN_A_GOLDEN,
    GEN_AT_GOLDEN,
    GEN_MATRIX_NBLOCKS,
    KYBER_N,
    KYBER_Q,
    SHAKE128_RATE,
    TEST_SEED,
    XOF_BLOCKBYTES,
)
from vectors_kyber_intt import KYBER_INTT_IN, KYBER_INTT_OUT
from vectors_kyber_ntt import KYBER_NTT_IN, KYBER_NTT_OUT, ZETAS_KEM
from vectors_prf_addr import PRF_ADDR_CASES
from vectors_thash1 import THASH1_CASES
from vectors_thash2 import THASH2_CASES


async def _reset_dut(dut, cycles=10):
    dut.rst_ni.value = 0
    for _ in range(cycles):
        await RisingEdge(dut.clk_i)
    dut.rst_ni.value = 1
    for _ in range(5):
        await RisingEdge(dut.clk_i)


async def _setup(dut, timeout_max=100000):
    clock = Clock(dut.clk_i, 10, unit="ns")
    cocotb.start_soon(clock.start())

    init_reset_before_host(dut)
    xif_bus = XifBus.from_prefix(dut, "s_xif")
    host = XifHost(xif_bus, dut.clk_i, reset=dut.rst_ni, timeout_max=timeout_max)
    XifMonitor(xif_bus, dut.clk_i)

    await _reset_dut(dut)
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


async def _keccak_absorb_once_hw(host, enc, msg: bytes, rate: int, domain: int) -> None:
    rate_words = rate // 4
    init_instr = enc.encode_r(FUNCT7_KINIT)
    absorb_instr = enc.encode_r4(FUNCT7_KABSORB, funct3=FUNCT3_KECCAK)
    perm_instr = enc.encode_r4(FUNCT7_KPERM, funct3=FUNCT3_KECCAK)

    await host.execute(init_instr, check_we=False)
    for _ in range(20):
        await RisingEdge(host.clock)

    remaining = memoryview(msg)
    while len(remaining) >= rate:
        block = remaining[:rate]
        for i in range(0, rate_words, 2):
            lo = struct.unpack("<I", block[4 * i : 4 * i + 4])[0]
            hi = struct.unpack("<I", block[4 * (i + 1) : 4 * (i + 2)])[0]
            await host.execute(
                absorb_instr,
                rs=(lo, hi, i),
                rs_valid=0b111,
                check_we=False,
            )
            for _ in range(10):
                await RisingEdge(host.clock)
        await host.execute(perm_instr, rs=(1, 0, 0), check_we=False)
        for _ in range(500):
            await RisingEdge(host.clock)
        remaining = remaining[rate:]

    xor_buf = [0] * rate_words
    tail = bytes(remaining)
    for i, byte in enumerate(tail):
        xor_buf[i // 4] |= byte << (8 * (i % 4))
    xor_buf[len(tail) // 4] |= domain << (8 * (len(tail) % 4))
    xor_buf[rate_words - 1] |= 0x80000000

    for i in range(0, rate_words, 2):
        lo = xor_buf[i]
        hi = xor_buf[i + 1]
        if lo | hi:
            await host.execute(
                absorb_instr,
                rs=(lo, hi, i),
                rs_valid=0b111,
                check_we=False,
            )
            for _ in range(10):
                await RisingEdge(host.clock)


async def _keccak_store_digest(host, enc, expected: bytes) -> None:
    store_instr = enc.encode_r(FUNCT7_KSTORE, rd=10, rs1=0, rs2=0)
    digest = bytearray()
    for word_idx in range(len(expected) // 4):
        exp = struct.unpack(
            "<I", expected[word_idx * 4 : (word_idx + 1) * 4]
        )[0]
        await host.execute(store_instr, rs=(word_idx, 0, 0), expected=exp)
        digest.extend(expected[word_idx * 4 : (word_idx + 1) * 4])
    if bytes(digest) != expected:
        raise RuntimeError(
            f"SHA3-256 mismatch: got {digest.hex()}, expected {expected.hex()}"
        )


async def _karats_hw(host, enc, a: int, b: int) -> tuple[int, int]:
    a_lo = a & 0xFFFFFFFF
    a_hi = (a >> 32) & 0xFFFFFFFF
    b_lo = b & 0xFFFFFFFF
    b_hi = (b >> 32) & 0xFFFFFFFF

    out1 = await host.execute(
        enc.encode_r(FUNCT7_KARATS_1), rs=(a_lo, b_lo), check_we=True
    )
    out2 = await host.execute(
        enc.encode_r(FUNCT7_KARATS_2), rs=(a_hi, b_hi), check_we=True
    )
    out3 = await host.execute(
        enc.encode_r(FUNCT7_KARATS_3), rs=(a_lo, b_lo), check_we=True
    )
    out4 = await host.execute(enc.encode_r(FUNCT7_KARATS_4), check_we=True)

    c0 = (out1.data & 0xFFFFFFFF) | ((out3.data & 0xFFFFFFFF) << 32)
    c1 = (out4.data & 0xFFFFFFFF) | ((out2.data & 0xFFFFFFFF) << 32)
    return c0, c1


async def _chain_lengths_hw(host, enc, vector: dict) -> list[int]:
    msg_words = _msg_words(vector["msg"])
    load_instr = enc.encode_r4(FUNCT2_LOAD, funct3=FUNCT3_LOAD)
    compute_instr = enc.encode_r(vector["cl_funct7"])
    store_instr = enc.encode_r(FUNCT7_KSTORE, rd=10, rs1=0, rs2=0)

    for load_idx in range(0, vector["nwords"], 2):
        lo = msg_words[load_idx]
        hi = msg_words[load_idx + 1]
        await host.execute(
            load_instr,
            rs=(lo, hi, load_idx),
            rs_valid=0b111,
            check_we=False,
        )
        for _ in range(10):
            await RisingEdge(host.clock)

    await host.execute(compute_instr, check_we=False)
    for _ in range(100):
        await RisingEdge(host.clock)

    words = []
    for store_idx in range(vector["nstores"]):
        result = await host.execute(
            store_instr, rs=(store_idx, 0, 0), check_we=True
        )
        words.append(result.data & 0xFFFFFFFF)

    return _unpack_nibbles(words)[: len(vector["expected"])]


def _to_i16(value: int) -> int:
    value &= 0xFFFF
    return value - 0x10000 if value >= 0x8000 else value


def _to_i32(value: int) -> int:
    value &= 0xFFFFFFFF
    return value - 0x100000000 if value >= 0x80000000 else value


def _to_i8(value: int) -> int:
    value &= 0xFF
    return value - 256 if value >= 0x80 else value


async def _keccak_load_bytes(host, enc, data: bytes, start_pair_idx: int) -> int:
    load_instr = enc.encode_r4(FUNCT2_LOAD, funct3=FUNCT3_LOAD)
    idx = start_pair_idx
    for offset in range(0, len(data), 8):
        lo = struct.unpack("<I", data[offset : offset + 4])[0]
        hi = struct.unpack("<I", data[offset + 4 : offset + 8])[0]
        await host.execute(
            load_instr,
            rs=(lo, hi, idx),
            rs_valid=0b111,
            check_we=False,
        )
        for _ in range(10):
            await RisingEdge(host.clock)
        idx += 2
    return idx


async def _keccak_absorb_xor(host, enc, lo: int, hi: int, pair_idx: int) -> None:
    absorb_instr = enc.encode_r4(FUNCT7_KABSORB, funct3=FUNCT3_KECCAK)
    await host.execute(
        absorb_instr,
        rs=(lo & 0xFFFFFFFF, hi & 0xFFFFFFFF, pair_idx),
        rs_valid=0b111,
        check_we=False,
    )
    for _ in range(10):
        await RisingEdge(host.clock)


async def _keccak_permute(host, enc) -> None:
    perm_instr = enc.encode_r4(FUNCT7_KPERM, funct3=FUNCT3_KECCAK)
    await host.execute(perm_instr, rs=(1, 0, 0), check_we=False)
    for _ in range(500):
        await RisingEdge(host.clock)


def _rej_uniform(buf: bytes, length: int, start: int = 0) -> tuple[list[int], int]:
    coeffs: list[int] = []
    pos = start
    while len(coeffs) < length and pos + 3 <= len(buf):
        val0 = ((buf[pos] >> 0) | (buf[pos + 1] << 8)) & 0xFFF
        val1 = ((buf[pos + 1] >> 4) | (buf[pos + 2] << 4)) & 0xFFF
        pos += 3
        if val0 < KYBER_Q:
            coeffs.append(val0)
        if len(coeffs) < length and val1 < KYBER_Q:
            coeffs.append(val1)
    return coeffs, pos


async def _xof_absorb_hw(host, enc, seed: bytes, x: int, y: int) -> None:
    await host.execute(enc.encode_r(FUNCT7_KINIT), check_we=False)
    for _ in range(20):
        await RisingEdge(host.clock)

    for pair_idx in range(0, 32 // 4, 2):
        lo = struct.unpack("<I", seed[4 * pair_idx : 4 * pair_idx + 4])[0]
        hi = struct.unpack("<I", seed[4 * (pair_idx + 1) : 4 * (pair_idx + 2)])[0]
        await _keccak_absorb_xor(host, enc, lo, hi, pair_idx)

    await _keccak_absorb_xor(host, enc, 0x1F, 0, 8)
    await _keccak_absorb_xor(host, enc, 0, 0x80000000, 40)
    await _keccak_permute(host, enc)

    w0 = (x & 0xFF) | ((y & 0xFF) << 8) | (0x1F << 16)
    await _keccak_absorb_xor(host, enc, w0, 0, 0)
    await _keccak_absorb_xor(host, enc, 0, 0x80000000, 40)


async def _gen_matrix_poly_hw(
    host, enc, seed: bytes, row_i: int, col_j: int, transposed: bool
) -> list[int]:
    x, y = (row_i, col_j) if transposed else (col_j, row_i)
    await _xof_absorb_hw(host, enc, seed, x, y)

    buf = bytearray()
    for _ in range(GEN_MATRIX_NBLOCKS):
        await _keccak_permute(host, enc)
        buf.extend(await _keccak_read_bytes(host, enc, SHAKE128_RATE))

    coeffs, pos = _rej_uniform(bytes(buf), KYBER_N)
    while len(coeffs) < KYBER_N:
        await _keccak_permute(host, enc)
        block = await _keccak_read_bytes(host, enc, XOF_BLOCKBYTES)
        more, pos = _rej_uniform(block, KYBER_N - len(coeffs))
        coeffs.extend(more)
        if pos >= len(block) and not more:
            raise RuntimeError("gen-matrix rejection sampling stalled")
    return coeffs[:KYBER_N]


async def _sphincs_keccak_hw(host, enc, case: dict) -> bytes:
    payload = case["payload"] if "payload" in case else case["sk_seed"]
    await host.execute(enc.encode_r(FUNCT7_KINIT), check_we=False)
    for _ in range(20):
        await RisingEdge(host.clock)

    idx = await _keccak_load_bytes(host, enc, case["pub_seed"], 0)
    idx = await _keccak_load_bytes(host, enc, case["addr"], idx)
    await _keccak_load_bytes(host, enc, payload, idx)

    thash_instr = enc.encode_r(case["funct7"], rd=0, rs1=0, rs2=0)
    simple_flag = 1 if case.get("simple_mode", 0) else 0
    await host.execute(
        thash_instr,
        rs=(0, simple_flag, 0),
        rs_valid=0b111,
        check_we=False,
    )
    for _ in range(200):
        await RisingEdge(host.clock)

    return await _keccak_read_bytes(host, enc, case["n"])


async def _thash1_hw(host, enc, case: dict) -> bytes:
    return await _sphincs_keccak_hw(host, enc, case)


async def _keccak_read_bytes(host, enc, length: int) -> bytes:
    store_instr = enc.encode_r(FUNCT7_KSTORE, rd=10, rs1=0, rs2=0)
    out = bytearray()
    word_idx = 0
    while len(out) + 4 <= length:
        result = await host.execute(store_instr, rs=(word_idx, 0, 0), check_we=True)
        out.extend(struct.pack("<I", result.data & 0xFFFFFFFF))
        word_idx += 1
    rem = length - len(out)
    if rem:
        result = await host.execute(store_instr, rs=(word_idx, 0, 0), check_we=True)
        word = result.data & 0xFFFFFFFF
        for byte in range(rem):
            out.append((word >> (8 * byte)) & 0xFF)
    return bytes(out)


async def _keccak_shake256_hw(host, enc, msg: bytes, outlen: int = 64) -> bytes:
    return await _keccak_shake_hw(host, enc, msg, outlen=outlen, rate=136)


async def _keccak_shake128_hw(host, enc, msg: bytes, outlen: int) -> bytes:
    return await _keccak_shake_hw(host, enc, msg, outlen=outlen, rate=168)


async def _keccak_shake_hw(
    host, enc, msg: bytes, *, outlen: int, rate: int
) -> bytes:
    await _keccak_absorb_once_hw(host, enc, msg, rate=rate, domain=0x1F)
    perm_instr = enc.encode_r4(FUNCT7_KPERM, funct3=FUNCT3_KECCAK)
    out = bytearray()
    remaining = outlen
    while remaining > 0:
        await host.execute(perm_instr, rs=(1, 0, 0), check_we=False)
        for _ in range(500):
            await RisingEdge(host.clock)
        chunk_len = rate if remaining >= rate else remaining
        out.extend(await _keccak_read_bytes(host, enc, chunk_len))
        remaining -= chunk_len
    return bytes(out)


async def _kyber_ntt_hw(host, enc, coeffs: list[int], zetas: list[int]) -> list[int]:
    c = list(coeffs)
    bf_instr = enc.encode_r4(FUNCT2_BFNTTK, funct3=7)
    k = 1
    length = 128
    while length >= 2:
        start = 0
        while start < 256:
            zeta = zetas[k]
            k += 1
            j = start
            while j < start + length - 1:
                for idx in (j, j + 1):
                    a_val = c[idx] & 0xFFFFFFFF
                    b_val = c[idx + length] & 0xFFFFFFFF
                    result = await host.execute(
                        bf_instr,
                        rs=(a_val, b_val, zeta & 0xFFFFFFFF),
                        rs_valid=0b111,
                        check_we=True,
                    )
                    c[idx] = _to_i16(result.data)
                    c[idx + length] = _to_i16(result.data >> 16)
                j += 2
            if j < start + length:
                a_val = c[j] & 0xFFFFFFFF
                b_val = c[j + length] & 0xFFFFFFFF
                result = await host.execute(
                    bf_instr,
                    rs=(a_val, b_val, zeta & 0xFFFFFFFF),
                    rs_valid=0b111,
                    check_we=True,
                )
                c[j] = _to_i16(result.data)
                c[j + length] = _to_i16(result.data >> 16)
            start += 2 * length
        length >>= 1
    return c


async def _dilithium_ntt_hw(host, enc, coeffs: list[int], zetas: list[int]) -> list[int]:
    c = list(coeffs)
    bf_instr = enc.encode_r4(FUNCT2_BFNTTD, funct3=7)
    hi_instr = enc.encode_r(FUNCT7_BFNTTDH)
    k = 0
    length = 128
    while length > 0:
        start = 0
        while start < 256:
            zeta = zetas[k + 1]
            k += 1
            j = start
            while j < start + length - 1:
                for idx in (j, j + 1):
                    result = await host.execute(
                        bf_instr,
                        rs=(
                            c[idx] & 0xFFFFFFFF,
                            c[idx + length] & 0xFFFFFFFF,
                            zeta & 0xFFFFFFFF,
                        ),
                        rs_valid=0b111,
                        check_we=True,
                    )
                    hi = await host.execute(hi_instr, check_we=True)
                    c[idx] = _to_i32(result.data)
                    c[idx + length] = _to_i32(hi.data)
                j += 2
            while j < start + length:
                result = await host.execute(
                    bf_instr,
                    rs=(
                        c[j] & 0xFFFFFFFF,
                        c[j + length] & 0xFFFFFFFF,
                        zeta & 0xFFFFFFFF,
                    ),
                    rs_valid=0b111,
                    check_we=True,
                )
                hi = await host.execute(hi_instr, check_we=True)
                c[j] = _to_i32(result.data)
                c[j + length] = _to_i32(hi.data)
                j += 1
            start += 2 * length
        length >>= 1
    return c


async def _kyber_intt_hw(host, enc, coeffs: list[int], zetas: list[int]) -> list[int]:
    c = list(coeffs)
    bf_instr = enc.encode_r4(FUNCT2_BFINTTK, funct3=7)
    mqmul_instr = enc.encode_r(FUNCT7_MQMULK)
    f = 1441
    k = 127
    length = 2
    while length <= 64:
        start = 0
        while start < 256:
            zeta = zetas[k]
            k -= 1
            j = start
            while j < start + length - 1:
                for idx in (j, j + 1):
                    result = await host.execute(
                        bf_instr,
                        rs=(
                            c[idx] & 0xFFFFFFFF,
                            c[idx + length] & 0xFFFFFFFF,
                            zeta & 0xFFFFFFFF,
                        ),
                        rs_valid=0b111,
                        check_we=True,
                    )
                    c[idx] = _to_i16(result.data)
                    c[idx + length] = _to_i16(result.data >> 16)
                j += 2
            while j < start + length:
                result = await host.execute(
                    bf_instr,
                    rs=(
                        c[j] & 0xFFFFFFFF,
                        c[j + length] & 0xFFFFFFFF,
                        zeta & 0xFFFFFFFF,
                    ),
                    rs_valid=0b111,
                    check_we=True,
                )
                c[j] = _to_i16(result.data)
                c[j + length] = _to_i16(result.data >> 16)
                j += 1
            start += 2 * length
        length <<= 1

    zeta = zetas[k]
    for j in range(0, 128, 2):
        bf_vals = []
        for idx in (j, j + 1):
            result = await host.execute(
                bf_instr,
                rs=(
                    c[idx] & 0xFFFFFFFF,
                    c[idx + 128] & 0xFFFFFFFF,
                    zeta & 0xFFFFFFFF,
                ),
                rs_valid=0b111,
                check_we=True,
            )
            bf_vals.append(result.data & 0xFFFFFFFF)

        for dst, part in (
            (j, bf_vals[0] & 0xFFFF),
            (j + 128, bf_vals[0] >> 16),
            (j + 1, bf_vals[1] & 0xFFFF),
            (j + 129, bf_vals[1] >> 16),
        ):
            scaled = await host.execute(
                mqmul_instr,
                rs=(_to_i16(part) & 0xFFFFFFFF, f & 0xFFFFFFFF),
                rs_valid=0b11,
                check_we=True,
            )
            c[dst] = _to_i16(scaled.data)
    return c


async def _dilithium_intt_hw(host, enc, coeffs: list[int], zetas: list[int]) -> list[int]:
    c = list(coeffs)
    bf_instr = enc.encode_r4(FUNCT2_BFINTTD, funct3=7)
    hi_instr = enc.encode_r(FUNCT7_BFINTTDH)
    scale_instr = enc.encode_r(FUNCT7_MQMULD)
    f = 41978
    k = 256
    length = 1
    while length < 256:
        start = 0
        while start < 256:
            k -= 1
            zeta = (-zetas[k]) & 0xFFFFFFFF
            j = start
            while j < start + length - 1:
                for idx in (j, j + 1):
                    result = await host.execute(
                        bf_instr,
                        rs=(
                            c[idx] & 0xFFFFFFFF,
                            c[idx + length] & 0xFFFFFFFF,
                            zeta,
                        ),
                        rs_valid=0b111,
                        check_we=True,
                    )
                    hi = await host.execute(hi_instr, check_we=True)
                    c[idx] = _to_i32(result.data)
                    c[idx + length] = _to_i32(hi.data)
                j += 2
            while j < start + length:
                result = await host.execute(
                    bf_instr,
                    rs=(
                        c[j] & 0xFFFFFFFF,
                        c[j + length] & 0xFFFFFFFF,
                        zeta,
                    ),
                    rs_valid=0b111,
                    check_we=True,
                )
                hi = await host.execute(hi_instr, check_we=True)
                c[j] = _to_i32(result.data)
                c[j + length] = _to_i32(hi.data)
                j += 1
            start += 2 * length
        length <<= 1

    for j in range(256):
        result = await host.execute(
            scale_instr,
            rs=(c[j] & 0xFFFFFFFF, f & 0xFFFFFFFF),
            rs_valid=0b11,
            check_we=True,
        )
        c[j] = _to_i32(result.data)
    return c


@cocotb.test()
async def test_fqmul(dut):
    enc = HorcruxEncoder()
    instr = enc.encode_r(FUNCT7_MQMULK)
    await _run_vector_table(dut, instr, FQMUL_TESTS)


@cocotb.test()
async def test_compare_u32(dut):
    enc = HorcruxEncoder()
    instr = enc.encode_r(FUNCT7_COMPARE_U32)
    await _run_vector_table(dut, instr, COMPARE_U32_TESTS)


@cocotb.test()
async def test_kyber_montg(dut):
    enc = HorcruxEncoder()
    instr = enc.encode_r(FUNCT7_MQMULK)
    vectors = [(a, 1, e) for a, e in KYBER_MONTG_TESTS]
    await _run_vector_table(dut, instr, vectors)


@cocotb.test()
async def test_dilithium_montg(dut):
    enc = HorcruxEncoder()
    instr = enc.encode_r(FUNCT7_MQMULD)
    vectors = [(a, 1, e) for a, e in DILITHIUM_MONTG_TESTS]
    await _run_vector_table(dut, instr, vectors)


@cocotb.test()
async def test_kyber_barrett(dut):
    enc = HorcruxEncoder()
    instr = enc.encode_r(FUNCT7_BARRETT_KYBER)
    vectors = [(a, 0, e) for a, e in KYBER_BARRETT_TESTS]
    await _run_vector_table(dut, instr, vectors)


@cocotb.test()
async def test_dilithium_reduce32(dut):
    enc = HorcruxEncoder()
    instr = enc.encode_r(FUNCT7_RED32)
    vectors = [(a, 0, e) for a, e in DILITHIUM_REDUCE32_TESTS]
    await _run_vector_table(dut, instr, vectors)


@cocotb.test()
async def test_hqc_barrett(dut):
    enc = HorcruxEncoder()
    instr = enc.encode_r(FUNCT7_BARRETT_HQC1)
    vectors = [(a, 0, e) for a, e in HQC_BARRETT_HQC1_TESTS]
    await _run_vector_table(dut, instr, vectors, exp_idx=2)


@cocotb.test()
async def test_hqc_barrett_hqc3(dut):
    enc = HorcruxEncoder()
    instr = enc.encode_r(FUNCT7_BARRETT_HQC3)
    vectors = [(a, 0, e) for a, e in HQC_BARRETT_HQC3_TESTS]
    await _run_vector_table(dut, instr, vectors, exp_idx=2)


@cocotb.test()
async def test_hqc_barrett_hqc5(dut):
    enc = HorcruxEncoder()
    instr = enc.encode_r(FUNCT7_BARRETT_HQC5)
    vectors = [(a, 0, e) for a, e in HQC_BARRETT_HQC5_TESTS]
    await _run_vector_table(dut, instr, vectors, exp_idx=2)


@cocotb.test()
async def test_gf_reduce(dut):
    enc = HorcruxEncoder()
    instr = enc.encode_r(FUNCT7_GFREDUCE)
    vectors = [(a, 0, e) for a, e in GF_REDUCE_TESTS]
    await _run_vector_table(dut, instr, vectors, exp_idx=2)


@cocotb.test(skip=True)
async def test_falcon_montg(dut):
    """Skipped: see tests/test_horcrux/SKIPPED_TESTS.md § test_falcon_montg."""
    enc = HorcruxEncoder()
    instr = enc.encode_r(FUNCT7_MONTG_FALCON)
    vectors = [(a, 1, e) for a, e in FALCON_MONTG_TESTS]
    await _run_vector_table(dut, instr, vectors, exp_idx=2)


@cocotb.test()
async def test_mq_montymul(dut):
    enc = HorcruxEncoder()
    instr = enc.encode_r(FUNCT7_MQMULF)
    vectors = [(a, b, e) for a, b, e in MQ_MONTYMUL_TESTS]
    await _run_vector_table(dut, instr, vectors, rs0_idx=0, rs1_idx=1, exp_idx=2)


@cocotb.test()
async def test_gf_carryless(dut):
    enc = HorcruxEncoder()
    instr = enc.encode_r(FUNCT7_GFMUL8)
    host, _ = await _setup(dut, timeout_max=200000)
    for a, b, c0, c1 in GF_CARRYLESS_TESTS:
        expected = (c1 << 8) | c0
        await host.execute(instr, rs=(a, b), expected=expected)


@cocotb.test()
async def test_karats(dut):
    host, enc = await _setup(dut, timeout_max=200000)
    for a, b, exp_c0, exp_c1 in KARATS_TESTS:
        got_c0, got_c1 = await _karats_hw(host, enc, a, b)
        if got_c0 != exp_c0 or got_c1 != exp_c1:
            raise RuntimeError(
                f"karats mismatch: a={a} b={b} "
                f"got=({got_c0}, {got_c1}) expected=({exp_c0}, {exp_c1})"
            )


@cocotb.test()
async def test_chain_lengths(dut):
    host, enc = await _setup(dut, timeout_max=300000)
    for vector in CHAIN_LENGTHS_VECTORS:
        got = await _chain_lengths_hw(host, enc, vector)
        if got != vector["expected"]:
            raise RuntimeError(
                f"chain_lengths {vector['name']} mismatch: "
                f"got {got}, expected {vector['expected']}"
            )


@cocotb.test()
async def test_keccak_sha3_256_abc(dut):
    host, enc = await _setup(dut, timeout_max=200000)

    init_instr = enc.encode_r(FUNCT7_KINIT)
    await host.execute(init_instr, check_we=False)
    for _ in range(50):
        await RisingEdge(host.clock)

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
            await host.execute(
                absorb_instr,
                rs=(lo, hi, i),
                rs_valid=0b111,
                check_we=False,
            )
            for _ in range(20):
                await RisingEdge(host.clock)

    perm_instr = enc.encode_r4(FUNCT7_KPERM, funct3=FUNCT3_KECCAK)
    await host.execute(perm_instr, rs=(1, 0, 0), check_we=False)
    for _ in range(500):
        await RisingEdge(host.clock)

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
async def test_keccak_sha3_256_multi_block(dut):
    host, enc = await _setup(dut, timeout_max=500000)
    msg = bytes(i & 0xFF for i in range(200))
    expected = hashlib.sha3_256(msg).digest()

    await _keccak_absorb_once_hw(host, enc, msg, rate=136, domain=0x06)
    await host.execute(
        enc.encode_r4(FUNCT7_KPERM, funct3=FUNCT3_KECCAK),
        rs=(1, 0, 0),
        check_we=False,
    )
    for _ in range(500):
        await RisingEdge(host.clock)
    await _keccak_store_digest(host, enc, expected)


@cocotb.test()
async def test_keccak_shake256(dut):
    host, enc = await _setup(dut, timeout_max=500000)
    msg = bytes(i & 0xFF for i in range(100))
    expected = hashlib.shake_256(msg).digest(64)
    got = await _keccak_shake256_hw(host, enc, msg, outlen=64)
    if got != expected:
        raise RuntimeError(
            f"SHAKE256 mismatch: got {got.hex()}, expected {expected.hex()}"
        )


@cocotb.test()
async def test_keccak_shake128_multi_squeeze(dut):
    host, enc = await _setup(dut, timeout_max=2000000)
    msg = bytes(i & 0xFF for i in range(50))
    expected = hashlib.shake_128(msg).digest(500)
    got = await _keccak_shake128_hw(host, enc, msg, outlen=500)
    if got != expected:
        raise RuntimeError(
            f"SHAKE128 multi-squeeze mismatch at byte "
            f"{next(i for i, (g, e) in enumerate(zip(got, expected)) if g != e)}"
        )


@cocotb.test()
async def test_kyber_intt(dut):
    host, enc = await _setup(dut, timeout_max=2500000)
    got = await _kyber_intt_hw(host, enc, KYBER_INTT_IN, ZETAS_KEM)
    if got != KYBER_INTT_OUT:
        for i, (g, e) in enumerate(zip(got, KYBER_INTT_OUT)):
            if g != e:
                raise RuntimeError(
                    f"kyber-intt mismatch @ {i}: got {g}, expected {e}"
                )


@cocotb.test()
async def test_dilithium_intt(dut):
    host, enc = await _setup(dut, timeout_max=3500000)
    got = await _dilithium_intt_hw(host, enc, DILITHIUM_INTT_IN, ZETAS_DSA)
    if got != DILITHIUM_INTT_OUT:
        for i, (g, e) in enumerate(zip(got, DILITHIUM_INTT_OUT)):
            if g != e:
                raise RuntimeError(
                    f"dilithium-intt mismatch @ {i}: got {g}, expected {e}"
                )


@cocotb.test()
async def test_kyber_ntt(dut):
    host, enc = await _setup(dut, timeout_max=2000000)
    got = await _kyber_ntt_hw(host, enc, KYBER_NTT_IN, ZETAS_KEM)
    if got != KYBER_NTT_OUT:
        for i, (g, e) in enumerate(zip(got, KYBER_NTT_OUT)):
            if g != e:
                raise RuntimeError(
                    f"kyber-ntt mismatch @ {i}: got {g}, expected {e}"
                )


@cocotb.test()
async def test_dilithium_ntt(dut):
    host, enc = await _setup(dut, timeout_max=3000000)
    got = await _dilithium_ntt_hw(host, enc, DILITHIUM_NTT_IN, ZETAS_DSA)
    if got != DILITHIUM_NTT_OUT:
        for i, (g, e) in enumerate(zip(got, DILITHIUM_NTT_OUT)):
            if g != e:
                raise RuntimeError(
                    f"dilithium-ntt mismatch @ {i}: got {g}, expected {e}"
                )


@cocotb.test()
async def test_cbd_eta1(dut):
    host, enc = await _setup(dut, timeout_max=500000)
    instr = enc.encode_r(FUNCT7_CBD1)
    for d_val, lane, expected in CBD_ETA1_TESTS:
        result = await host.execute(
            instr,
            rs=(d_val & 0xFFFFFFFF, lane),
            rs_valid=0b11,
            check_we=True,
        )
        got = _to_i8(result.data)
        if got != expected:
            raise RuntimeError(
                f"cbd_eta1 mismatch: d={d_val} lane={lane} got={got} expected={expected}"
            )


@cocotb.test()
async def test_thash1(dut):
    host, enc = await _setup(dut, timeout_max=1000000)
    for case in THASH1_CASES:
        got = await _thash1_hw(host, enc, case)
        if got != case["expected"]:
            raise RuntimeError(
                f"{case['name']} mismatch: got {got.hex()}, expected {case['expected'].hex()}"
            )


@cocotb.test()
async def test_thash2(dut):
    host, enc = await _setup(dut, timeout_max=1500000)
    for case in THASH2_CASES:
        got = await _sphincs_keccak_hw(host, enc, case)
        if got != case["expected"]:
            raise RuntimeError(
                f"{case['name']} mismatch: got {got.hex()}, expected {case['expected'].hex()}"
            )


@cocotb.test()
async def test_prf_addr(dut):
    host, enc = await _setup(dut, timeout_max=1000000)
    for case in PRF_ADDR_CASES:
        got = await _sphincs_keccak_hw(host, enc, case)
        if got != case["expected"]:
            raise RuntimeError(
                f"{case['name']} mismatch: got {got.hex()}, expected {case['expected'].hex()}"
            )


@cocotb.test()
async def test_cbd_eta2(dut):
    host, enc = await _setup(dut, timeout_max=300000)
    instr = enc.encode_r(FUNCT7_CBD2)
    for d_val, lane, expected in CBD_ETA2_TESTS:
        result = await host.execute(
            instr,
            rs=(d_val & 0xFFFFFFFF, lane),
            rs_valid=0b11,
            check_we=True,
        )
        got = _to_i8(result.data)
        if got != expected:
            raise RuntimeError(
                f"cbd_eta2 mismatch: d={d_val} lane={lane} got={got} expected={expected}"
            )


@cocotb.test()
async def test_gen_matrix(dut):
    host, enc = await _setup(dut, timeout_max=3000000)
    for (row, col), expected in GEN_A_GOLDEN.items():
        coeffs = await _gen_matrix_poly_hw(host, enc, TEST_SEED, row, col, False)
        if coeffs[:4] != expected:
            raise RuntimeError(
                f"gen_a[{row}][{col}] mismatch: got {coeffs[:4]}, expected {expected}"
            )
    for (row, col), expected in GEN_AT_GOLDEN.items():
        coeffs = await _gen_matrix_poly_hw(host, enc, TEST_SEED, row, col, True)
        if coeffs[:4] != expected:
            raise RuntimeError(
                f"gen_at[{row}][{col}] mismatch: got {coeffs[:4]}, expected {expected}"
            )


@cocotb.test()
async def test_kyber_ntt_butterfly_r4(dut):
    a, b, zeta = KYBER_NTT_BF_INPUT
    enc = HorcruxEncoder()
    instr = enc.encode_r4(FUNCT2_BFNTTK, funct3=7)
    host, _ = await _setup(dut)
    await host.execute(
        instr,
        rs=(a & 0xFFFFFFFF, b & 0xFFFFFFFF, zeta & 0xFFFFFFFF),
        rs_valid=0b111,
        expected=KYBER_NTT_BF_EXPECTED,
    )


from test_dut_remaining import *  # noqa: E402,F401,F403
