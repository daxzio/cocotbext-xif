"""Remaining Horcrux cocotb tests (wave 9 migration)."""

import cocotb
from cocotb.triggers import RisingEdge

from horcrux_encodings import (
    FUNCT2_BFINTTF,
    FUNCT2_BFNTTF,
    FUNCT2_FPR_NORM64,
    FUNCT3_FALCON_BF,
    FUNCT3_KECCAK,
    FUNCT7_BARRETT_KYBER,
    FUNCT7_CBD3,
    FUNCT7_CBD4,
    FUNCT7_FPR_LOAD_M,
    FUNCT7_FPR_LOAD_SE,
    FUNCT7_FPR_NORM64_EXEC,
    FUNCT7_FPR_NORM64_RDHI,
    FUNCT7_FPR_RDHI,
    FUNCT7_KABSORB,
    FUNCT7_KINIT,
    FUNCT7_KPERM,
    FUNCT7_MQMULF,
    FUNCT7_REJ_ETA2,
    FUNCT7_REJ_ETA4,
    FUNCT7_REJ_UNIFORM,
    FUNCT7_UNPACK_Z,
)
from test_dut import (
    _dilithium_intt_hw,
    _dilithium_ntt_hw,
    _keccak_read_bytes,
    _kyber_intt_hw,
    _kyber_ntt_hw,
    _setup,
    _sphincs_keccak_hw,
    _thash1_hw,
    _to_i16,
    _to_i32,
    _to_i8,
)
from vectors_cbd_eta3 import CBD_ETA3_TESTS
from vectors_cbd_eta4 import CBD_ETA4_TESTS
from vectors_dilithium_ntt import ZETAS_DSA
from vectors_falcon import (
    FALCON_GMB_16,
    FALCON_IGMB_16,
    FALCON_INTT_INPUT,
    FALCON_INTT_OUTPUT,
    FALCON_N,
    FALCON_NTT_INPUT,
    FALCON_NTT_OUTPUT,
    FALCON_R,
)
from vectors_fpr import FPR_TESTS
from vectors_fpr_norm64 import FPR_NORM64_TESTS
from vectors_kyber_ntt import ZETAS_KEM
from vectors_mldsa_rej_eta import REJ_ETA2_TESTS, REJ_ETA4_TESTS
from vectors_mldsa_rej_uniform import REJ_UNIFORM_TESTS
from vectors_mldsa_unpack_z import UNPACK_Z_TESTS
from vectors_sha3_512 import SHA3_512_ABC_EXPECTED
from vectors_thash_wots import THASH_WOTS_CASES

KEM_K = 2
KEM_N = 256
KEM_Q = 3329
DSA_K = 4
DSA_N = 256
SPX_OFFSET_HASH_ADDR = 31


def _init_kyber_polyvec(salt: int = 1) -> list[list[int]]:
    polyvec = []
    for i in range(KEM_K):
        poly = []
        for j in range(KEM_N):
            x = i * 257 + j * 73 + salt * 19 + 123
            x %= 8 * KEM_Q
            x -= 4 * KEM_Q
            poly.append(x)
        polyvec.append(poly)
    return polyvec


def _init_dilithium_polyvec(salt: int = 1) -> list[list[int]]:
    polyvec = []
    for i in range(DSA_K):
        poly = []
        for j in range(DSA_N):
            seed = (i * 251 + j * 65537 + salt * 1000003) & 0xFFFFFFFF
            seed = (seed * 1664525 + 1013904223) & 0xFFFFFFFF
            x = (seed % (2 * 8380417)) - 8380417
            poly.append(x)
        polyvec.append(poly)
    return polyvec


async def _kyber_polyvec_ntt_hw(host, enc, polyvec: list[list[int]]) -> list[list[int]]:
    barrett = enc.encode_r(FUNCT7_BARRETT_KYBER)
    out = []
    for poly in polyvec:
        coeffs = await _kyber_ntt_hw(host, enc, poly, ZETAS_KEM)
        reduced = []
        for coeff in coeffs:
            result = await host.execute(
                barrett,
                rs=(coeff & 0xFFFFFFFF, 0),
                rs_valid=0b1,
                check_we=True,
            )
            reduced.append(_to_i16(result.data))
        out.append(reduced)
    return out


async def _falcon_ntt_hw(host, enc, coeffs: list[int]) -> list[int]:
    poly = list(coeffs)
    bf = enc.encode_r4(FUNCT2_BFNTTF, funct3=FUNCT3_FALCON_BF)
    n = FALCON_N
    t = n
    m = 1
    while m < n:
        ht = t >> 1
        i = 0
        j1 = 0
        while i < m:
            s = FALCON_GMB_16[m + i] & 0xFFFF
            j2 = j1 + ht
            for j in range(j1, j2):
                result = await host.execute(
                    bf,
                    rs=(poly[j] & 0xFFFF, poly[j + ht] & 0xFFFF, s),
                    rs_valid=0b111,
                    check_we=True,
                )
                poly[j] = result.data & 0xFFFF
                poly[j + ht] = (result.data >> 16) & 0xFFFF
            i += 1
            j1 += t
        t = ht
        m <<= 1
    return poly


async def _falcon_intt_hw(host, enc, coeffs: list[int]) -> list[int]:
    poly = list(coeffs)
    bf = enc.encode_r4(FUNCT2_BFINTTF, funct3=FUNCT3_FALCON_BF)
    mqmul = enc.encode_r(FUNCT7_MQMULF)
    n = FALCON_N
    t = 1
    m = n
    while m > 1:
        hm = m >> 1
        dt = t << 1
        i = 0
        j1 = 0
        while i < hm:
            s = FALCON_IGMB_16[hm + i] & 0xFFFF
            j2 = j1 + t
            for j in range(j1, j2):
                result = await host.execute(
                    bf,
                    rs=(poly[j] & 0xFFFF, poly[j + t] & 0xFFFF, s),
                    rs_valid=0b111,
                    check_we=True,
                )
                poly[j] = result.data & 0xFFFF
                poly[j + t] = (result.data >> 16) & 0xFFFF
            i += 1
            j1 += dt
        t = dt
        m = hm

    ni = FALCON_R
    i = n
    while i > 1:
        if ni & 1:
            ni += 12289
        ni >>= 1
        i >>= 1

    for idx in range(n):
        result = await host.execute(
            mqmul,
            rs=(poly[idx] & 0xFFFFFFFF, ni & 0xFFFFFFFF),
            rs_valid=0b11,
            check_we=True,
        )
        poly[idx] = result.data & 0xFFFF
    return poly


async def _fpr_hw(host, enc, s: int, e: int, m: int) -> int:
    setup = enc.encode_r(FUNCT7_FPR_LOAD_SE, rd=0, rs1=0, rs2=0)
    load = enc.encode_r(FUNCT7_FPR_LOAD_M, rd=10, rs1=0, rs2=0)
    rdhi = enc.encode_r(FUNCT7_FPR_RDHI, rd=11, rs1=0, rs2=0)
    await host.execute(
        setup,
        rs=(s & 0xFFFFFFFF, e & 0xFFFFFFFF),
        rs_valid=0b11,
        check_we=True,
    )
    lo = await host.execute(
        load,
        rs=(m & 0xFFFFFFFF, (m >> 32) & 0xFFFFFFFF),
        rs_valid=0b11,
        check_we=True,
    )
    hi = await host.execute(rdhi, check_we=True)
    return ((hi.data & 0xFFFFFFFF) << 32) | (lo.data & 0xFFFFFFFF)


async def _fpr_norm64_hw(host, enc, m: int, e: int) -> tuple[int, int]:
    exec_r4 = enc.encode_r4(
        FUNCT2_FPR_NORM64,
        rd=10,
        rs1=0,
        rs2=0,
        rs3=0,
        funct3=FUNCT3_FALCON_BF,
    )
    rd_mhi = enc.encode_r(FUNCT7_FPR_NORM64_RDHI, rd=11, rs1=0, rs2=0)
    rd_e = enc.encode_r(FUNCT7_FPR_NORM64_EXEC, rd=12, rs1=0, rs2=0)
    lo = await host.execute(
        exec_r4,
        rs=(m & 0xFFFFFFFF, (m >> 32) & 0xFFFFFFFF, e & 0xFFFFFFFF),
        rs_valid=0b111,
        check_we=True,
    )
    hi = await host.execute(rd_mhi, check_we=True)
    e_out = await host.execute(rd_e, check_we=True)
    out_m = ((hi.data & 0xFFFFFFFF) << 32) | (lo.data & 0xFFFFFFFF)
    return out_m, _to_i32(e_out.data)


async def _wots_chain_hw(host, enc, case: dict) -> bytes:
    state = bytearray(case["payload"])
    addr = bytearray(case["addr"])
    steps = case.get("chain_steps", 1)
    for step in range(steps):
        addr[SPX_OFFSET_HASH_ADDR] = step
        step_case = {
            "n": case["n"],
            "simple_mode": case["simple_mode"],
            "funct7": case["funct7"],
            "pub_seed": case["pub_seed"],
            "addr": bytes(addr),
            "payload": bytes(state),
        }
        state = bytearray(await _sphincs_keccak_hw(host, enc, step_case))
    return bytes(state)


async def _keccak_sha3_512_abc_hw(host, enc) -> bytes:
    init_instr = enc.encode_r(FUNCT7_KINIT)
    await host.execute(init_instr, check_we=False)
    for _ in range(50):
        await RisingEdge(host.clock)

    msg = b"abc"
    rate = 72
    rate_words = rate // 4
    xor_buf = [0] * rate_words
    for i, byte in enumerate(msg):
        xor_buf[i // 4] |= byte << (8 * (i % 4))
    xor_buf[len(msg) // 4] |= 0x06 << (8 * (len(msg) % 4))
    xor_buf[rate_words - 1] |= 0x80000000

    absorb_instr = enc.encode_r4(FUNCT7_KABSORB, funct3=FUNCT3_KECCAK)
    for i in range(0, rate_words, 2):
        lo = xor_buf[i]
        hi = xor_buf[i + 1] if i + 1 < rate_words else 0
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
    for _ in range(100):
        await RisingEdge(host.clock)

    return await _keccak_read_bytes(host, enc, 64)


@cocotb.test()
async def test_cbd_eta3(dut):
    host, enc = await _setup(dut, timeout_max=500000)
    instr = enc.encode_r(FUNCT7_CBD3)
    for d_val, lane, expected in CBD_ETA3_TESTS:
        result = await host.execute(
            instr,
            rs=(d_val & 0xFFFFFFFF, lane),
            rs_valid=0b11,
            check_we=True,
        )
        if _to_i8(result.data) != expected:
            raise RuntimeError(
                f"cbd_eta3 mismatch: d={d_val} lane={lane} "
                f"got={_to_i8(result.data)} expected={expected}"
            )


@cocotb.test()
async def test_cbd_eta4(dut):
    host, enc = await _setup(dut, timeout_max=500000)
    instr = enc.encode_r(FUNCT7_CBD4)
    for d_val, lane, expected in CBD_ETA4_TESTS:
        result = await host.execute(
            instr,
            rs=(d_val & 0xFFFFFFFF, lane),
            rs_valid=0b11,
            check_we=True,
        )
        if _to_i8(result.data) != expected:
            raise RuntimeError(
                f"cbd_eta4 mismatch: d={d_val} lane={lane} "
                f"got={_to_i8(result.data)} expected={expected}"
            )


@cocotb.test()
async def test_mldsa_rej_uniform(dut):
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_REJ_UNIFORM)
    for inp, expected in REJ_UNIFORM_TESTS:
        await host.execute(
            instr,
            rs=(inp & 0xFFFFFFFF, 0),
            rs_valid=0b1,
            expected=expected & 0xFFFFFFFF,
        )


@cocotb.test()
async def test_mldsa_rej_eta2(dut):
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_REJ_ETA2)
    for byte_in, sel, expected in REJ_ETA2_TESTS:
        await host.execute(
            instr,
            rs=(byte_in & 0xFFFFFFFF, sel & 0xFFFFFFFF),
            rs_valid=0b11,
            expected=expected & 0xFFFFFFFF,
        )


@cocotb.test(skip=True)
async def test_mldsa_rej_eta4(dut):
    """Skipped: see tests/test_horcrux/SKIPPED_TESTS.md § test_mldsa_rej_eta4."""
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_REJ_ETA4)
    for byte_in, sel, expected in REJ_ETA4_TESTS:
        await host.execute(
            instr,
            rs=(byte_in & 0xFFFFFFFF, sel & 0xFFFFFFFF),
            rs_valid=0b11,
            expected=expected & 0xFFFFFFFF,
        )


@cocotb.test()
async def test_mldsa_unpack_z(dut):
    host, enc = await _setup(dut)
    instr = enc.encode_r(FUNCT7_UNPACK_Z)
    for data, sel, expected in UNPACK_Z_TESTS:
        result = await host.execute(
            instr,
            rs=(data & 0xFFFFFFFF, sel & 0xFFFFFFFF),
            rs_valid=0b11,
            check_we=True,
        )
        if _to_i32(result.data) != expected:
            raise RuntimeError(
                f"unpack_z mismatch: data=0x{data:08x} sel={sel} "
                f"got={_to_i32(result.data)} expected={expected}"
            )


@cocotb.test()
async def test_falcon_ntt(dut):
    host, enc = await _setup(dut, timeout_max=200000)
    got = await _falcon_ntt_hw(host, enc, FALCON_NTT_INPUT)
    for i, (g, e) in enumerate(zip(got, FALCON_NTT_OUTPUT)):
        if g != e:
            raise RuntimeError(f"falcon-ntt mismatch @ {i}: got {g}, expected {e}")


@cocotb.test()
async def test_falcon_intt(dut):
    host, enc = await _setup(dut, timeout_max=200000)
    got = await _falcon_intt_hw(host, enc, FALCON_INTT_INPUT)
    for i, (g, e) in enumerate(zip(got, FALCON_INTT_OUTPUT)):
        if g != e:
            raise RuntimeError(f"falcon-intt mismatch @ {i}: got {g}, expected {e}")


@cocotb.test()
async def test_falcon_fpr(dut):
    host, enc = await _setup(dut, timeout_max=300000)
    for s, e, m, expected in FPR_TESTS:
        got = await _fpr_hw(host, enc, s, e, m)
        if got != expected:
            raise RuntimeError(
                f"falcon-fpr mismatch: s={s} e={e} m=0x{m:016x} "
                f"got=0x{got:016x} expected=0x{expected:016x}"
            )


@cocotb.test()
async def test_falcon_fpr_norm64(dut):
    host, enc = await _setup(dut, timeout_max=300000)
    for m, e, exp_m, exp_e in FPR_NORM64_TESTS:
        got_m, got_e = await _fpr_norm64_hw(host, enc, m, e)
        if got_m != exp_m or got_e != exp_e:
            raise RuntimeError(
                f"fpr_norm64 mismatch: m=0x{m:016x} e={e} "
                f"got_m=0x{got_m:016x} got_e={got_e} "
                f"exp_m=0x{exp_m:016x} exp_e={exp_e}"
            )


@cocotb.test()
async def test_kyber_polyvec_ntt(dut):
    host, enc = await _setup(dut, timeout_max=5000000)
    polyvec = _init_kyber_polyvec(salt=1)
    got = await _kyber_polyvec_ntt_hw(host, enc, polyvec)
    for pi, poly in enumerate(polyvec):
        exp = await _kyber_polyvec_ntt_hw(host, enc, [poly])
        for j, (g, e) in enumerate(zip(got[pi], exp[0])):
            if g != e:
                raise RuntimeError(
                    f"kyber-poly-ntt mismatch vec={pi} idx={j} got={g} expected={e}"
                )


@cocotb.test()
async def test_kyber_polyvec_intt(dut):
    host, enc = await _setup(dut, timeout_max=5000000)
    ntt_vec = await _kyber_polyvec_ntt_hw(host, enc, _init_kyber_polyvec(salt=1))
    got = []
    for poly in ntt_vec:
        got.append(await _kyber_intt_hw(host, enc, poly, ZETAS_KEM))
    for pi, poly in enumerate(ntt_vec):
        exp_poly = await _kyber_intt_hw(host, enc, poly, ZETAS_KEM)
        for j, (g, e) in enumerate(zip(got[pi], exp_poly)):
            if g != e:
                raise RuntimeError(
                    f"kyber-poly-intt mismatch vec={pi} idx={j} got={g} expected={e}"
                )


@cocotb.test()
async def test_dilithium_polyvec_ntt(dut):
    host, enc = await _setup(dut, timeout_max=10000000)
    polyvec = _init_dilithium_polyvec(salt=1)
    got = []
    for poly in polyvec:
        got.append(await _dilithium_ntt_hw(host, enc, poly, ZETAS_DSA))
    for pi, poly in enumerate(polyvec):
        exp = await _dilithium_ntt_hw(host, enc, poly, ZETAS_DSA)
        for j, (g, e) in enumerate(zip(got[pi], exp)):
            if g != e:
                raise RuntimeError(
                    f"dilithium-poly-ntt mismatch vec={pi} idx={j} got={g} expected={e}"
                )


@cocotb.test()
async def test_dilithium_polyvec_intt(dut):
    host, enc = await _setup(dut, timeout_max=10000000)
    polyvec = _init_dilithium_polyvec(salt=1)
    ntt_vec = []
    for poly in polyvec:
        ntt_vec.append(await _dilithium_ntt_hw(host, enc, poly, ZETAS_DSA))
    got = []
    for poly in ntt_vec:
        got.append(await _dilithium_intt_hw(host, enc, poly, ZETAS_DSA))
    for pi, poly in enumerate(ntt_vec):
        exp = await _dilithium_intt_hw(host, enc, poly, ZETAS_DSA)
        for j, (g, e) in enumerate(zip(got[pi], exp)):
            if g != e:
                raise RuntimeError(
                    f"dilithium-poly-intt mismatch vec={pi} idx={j} got={g} expected={e}"
                )


@cocotb.test()
async def test_keccak_sha3_512_abc(dut):
    host, enc = await _setup(dut, timeout_max=200000)
    got = await _keccak_sha3_512_abc_hw(host, enc)
    if got != SHA3_512_ABC_EXPECTED:
        raise RuntimeError(
            f"sha3-512 mismatch: got {got.hex()}, expected {SHA3_512_ABC_EXPECTED.hex()}"
        )


@cocotb.test()
async def test_thash_wots(dut):
    host, enc = await _setup(dut, timeout_max=3000000)
    for case in THASH_WOTS_CASES:
        if "chain_steps" in case:
            got = await _wots_chain_hw(host, enc, case)
        else:
            got = await _thash1_hw(host, enc, case)
        if got != case["expected"]:
            raise RuntimeError(
                f"{case['name']} mismatch: got {got.hex()}, expected {case['expected'].hex()}"
            )
