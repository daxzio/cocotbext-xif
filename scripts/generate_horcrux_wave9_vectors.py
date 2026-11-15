#!/usr/bin/env python3
"""Generate vector modules for remaining Horcrux cocotb tests (wave 9)."""

from __future__ import annotations

import hashlib
import re
import struct
from pathlib import Path

HORCRUX_TESTS = Path.home() / "projects/horcrux/sw/applications/tests"
OUT_DIR = Path(__file__).resolve().parents[1] / "tests/test_horcrux"

GAMMA1 = 131072
Q_MLDSA = 8380417
SPX_ADDR_BYTES = 32


def _write(path: Path, content: str) -> None:
    path.write_text(content, encoding="utf-8")
    print(f"wrote {path}")


def _parse_c_int_arrays(main_c: Path, names: list[str]) -> dict[str, list[int]]:
    text = main_c.read_text(encoding="utf-8")
    out: dict[str, list[int]] = {}
    for name in names:
        m = re.search(
            rf"static const int32_t {name}\[[^\]]+\]\s*=\s*\{{([^;]+)\}};",
            text,
            re.S,
        )
        if not m:
            m = re.search(
                rf"static const int8_t {name}\[[^\]]+\]\[[^\]]+\]\s*=\s*\{{([^;]+)\}};",
                text,
                re.S,
            )
        if not m:
            raise RuntimeError(f"could not parse {name} from {main_c}")
        nums = [int(x, 0) for x in re.findall(r"-?0x[0-9a-fA-F]+|-?\d+", m.group(1))]
        out[name] = nums
    return out


def _parse_cbd(main_c: Path, d_name: str, golden_name: str, nlanes: int) -> None:
    text = main_c.read_text(encoding="utf-8")
    d_m = re.search(
        rf"static const int32_t {d_name}\[[^\]]+\]\s*=\s*\{{([^;]+)\}};",
        text,
        re.S,
    )
    g_m = re.search(
        rf"static const int8_t {golden_name}\[[^\]]+\]\[[^\]]+\]\s*=\s*\{{([^;]+)\}};",
        text,
        re.S,
    )
    if not d_m or not g_m:
        raise RuntimeError(f"parse failed for {main_c}")
    d_vals = [int(x, 0) for x in re.findall(r"-?0x[0-9a-fA-F]+|-?\d+", d_m.group(1))]
    g_flat = [int(x, 0) for x in re.findall(r"-?0x[0-9a-fA-F]+|-?\d+", g_m.group(1))]
    tests = []
    for i, d_val in enumerate(d_vals):
        row = g_flat[i * nlanes : (i + 1) * nlanes]
        for lane, expected in enumerate(row):
            tests.append((d_val, lane, expected))
    tag = Path(main_c).parent.name.replace("-", "_").upper()
    body = ",\n    ".join(f"({d}, {lane}, {exp})" for d, lane, exp in tests)
    _write(
        OUT_DIR / f"vectors_{Path(main_c).parent.name}.py",
        f'"""Auto-generated from {main_c}."""\n\n'
        f"{tag}_TESTS = [\n    {body},\n]\n",
    )


def rej_uniform_sw(inp: int) -> int:
    t = inp & 0x7FFFFF
    if t < Q_MLDSA:
        return (1 << 31) | t
    return 0


def rej_eta2_sw(byte_in: int, nibble_sel: int) -> int:
    nibble = (byte_in >> 4) & 0xF if nibble_sel & 1 else byte_in & 0xF
    if nibble >= 15:
        return 0
    mult = 205 * nibble
    div5 = mult >> 10
    mod5 = nibble - div5 * 5
    coeff = 2 - mod5
    return (1 << 31) | (coeff & 0x7FFFFFFF)


def rej_eta4_sw(byte_in: int, nibble_sel: int) -> int:
    nibble = (byte_in >> 4) & 0xF if nibble_sel & 1 else byte_in & 0xF
    if nibble >= 9:
        return 0
    coeff = 4 - nibble
    return (1 << 31) | (coeff & 0x7FFFFFFF)


def unpack_z_sw(data: int, selector: int) -> int:
    sel = selector & 0x3
    if sel == 0:
        raw18 = data & 0x3FFFF
    elif sel == 1:
        raw18 = (data >> 2) & 0x3FFFF
    elif sel == 2:
        raw18 = (data >> 4) & 0x3FFFF
    else:
        raw18 = (data >> 6) & 0x3FFFF
    return GAMMA1 - raw18


def fpr_golden(s: int, e: int, m: int) -> int:
    e_adj = e + 1076
    t = (e_adj >> 31) & 0xFFFFFFFF
    m &= ((1 << 64) - 1) if t == 0 else 0
    t = (m >> 54) & 0xFFFFFFFF
    if t:
        e_adj = 0
    x = (((s & 1) << 63) | (m >> 2)) + ((e_adj & 0xFFFFFFFF) << 52)
    f = m & 7
    x += (0xC8 >> f) & 1
    return x & ((1 << 64) - 1)


def fpr_norm64_sw(m: int, e: int) -> tuple[int, int]:
    m &= (1 << 64) - 1
    e = int(e)

    def step(shift: int, einc: int) -> None:
        nonlocal m, e
        nt = (m >> shift) & 0xFFFFFFFF
        nt = (nt | (-nt & 0xFFFFFFFF)) >> 31
        mask = (nt - 1) & ((1 << 64) - 1)
        m ^= ((m ^ ((m << shift) & ((1 << 64) - 1))) & mask)
        e += nt * einc

    e -= 63
    step(32, 5)
    step(48, 4)
    step(56, 3)
    step(60, 2)
    step(62, 1)
    nt = (m >> 63) & 1
    m ^= ((m ^ ((m << 1) & ((1 << 64) - 1))) & (nt - 1))
    e += nt
    return m, e


def spx_fill_bytes(length: int, seed: int) -> bytes:
    x = (seed ^ 0x9E3779B9) & 0xFFFFFFFF
    out = bytearray()
    for _ in range(length):
        x = (x ^ ((x << 13) & 0xFFFFFFFF)) & 0xFFFFFFFF
        x = (x ^ (x >> 17)) & 0xFFFFFFFF
        x = (x ^ ((x << 5) & 0xFFFFFFFF)) & 0xFFFFFFFF
        out.append(x & 0xFF)
    return bytes(out)


def spx_ref_thash(
    in_bytes: bytes,
    pub_seed: bytes,
    addr: bytes,
    n: int,
    simple_mode: int,
) -> bytes:
    inlen = len(in_bytes)
    prefix = pub_seed[:n] + addr[:SPX_ADDR_BYTES]
    if simple_mode:
        buf = prefix + in_bytes
        return hashlib.shake_256(buf).digest(n)
    bitmask = hashlib.shake_256(prefix).digest(inlen)
    buf = prefix + bytes(a ^ b for a, b in zip(in_bytes, bitmask))
    return hashlib.shake_256(buf).digest(n)


def thash_funct7_for_n(n: int) -> int:
    if n == 16:
        return 0x30
    if n == 24:
        return 0x3C
    return 0x3E


def gen_mldsa_rej_uniform() -> None:
    text = (HORCRUX_TESTS / "mldsa-rej-uniform/main.c").read_text(encoding="utf-8")
    m = re.search(r"static const uint32_t inputs\[NTESTS\]\s*=\s*\{([^;]+)\};", text, re.S)
    assert m
    inputs = [int(x, 0) for x in re.findall(r"0x[0-9a-fA-F]+", m.group(1))]
    rows = [(inp, rej_uniform_sw(inp)) for inp in inputs]
    body = ",\n    ".join(f"({a}, {b})" for a, b in rows)
    _write(
        OUT_DIR / "vectors_mldsa_rej_uniform.py",
        f'"""Auto-generated from mldsa-rej-uniform/main.c."""\n\n'
        f"REJ_UNIFORM_TESTS = [\n    {body},\n]\n",
    )


def gen_mldsa_rej_eta() -> None:
    text = (HORCRUX_TESTS / "mldsa-rej-eta/main.c").read_text(encoding="utf-8")
    m = re.search(
        r"static const uint32_t byte_inputs\[NTESTS/2\]\s*=\s*\{([^;]+)\};",
        text,
        re.S,
    )
    assert m
    byte_inputs = [int(x, 0) for x in re.findall(r"0x[0-9a-fA-F]+", m.group(1))]
    eta2 = []
    eta4 = []
    for byte_in in byte_inputs:
        for sel in (0, 1):
            eta2.append((byte_in, sel, rej_eta2_sw(byte_in, sel)))
            eta4.append((byte_in, sel, rej_eta4_sw(byte_in, sel)))
    body2 = ",\n    ".join(f"({a}, {b}, {c})" for a, b, c in eta2)
    body4 = ",\n    ".join(f"({a}, {b}, {c})" for a, b, c in eta4)
    _write(
        OUT_DIR / "vectors_mldsa_rej_eta.py",
        f'"""Auto-generated from mldsa-rej-eta/main.c."""\n\n'
        f"REJ_ETA2_TESTS = [\n    {body2},\n]\n\n"
        f"REJ_ETA4_TESTS = [\n    {body4},\n]\n",
    )


def gen_mldsa_unpack_z() -> None:
    text = (HORCRUX_TESTS / "mldsa-unpack-z/main.c").read_text(encoding="utf-8")
    m = re.search(r"static const uint32_t data_inputs\[NTESTS\]\s*=\s*\{([^;]+)\};", text, re.S)
    assert m
    data_inputs = [int(x, 0) for x in re.findall(r"0x[0-9a-fA-F]+", m.group(1))]
    rows = []
    for data in data_inputs:
        for sel in range(4):
            rows.append((data, sel, unpack_z_sw(data, sel)))
    body = ",\n    ".join(f"({a}, {b}, {c})" for a, b, c in rows)
    _write(
        OUT_DIR / "vectors_mldsa_unpack_z.py",
        f'"""Auto-generated from mldsa-unpack-z/main.c."""\n\n'
        f"UNPACK_Z_TESTS = [\n    {body},\n]\n",
    )


def gen_falcon() -> None:
    falcon_c = (HORCRUX_TESTS / "falcon-ntt/falcon.c").read_text(encoding="utf-8")

    def grab(name: str) -> list[int]:
        m = re.search(
            rf"const uint16_t {name}\[[^\]]+\]\s*=\s*\{{([^}}]+)\}};",
            falcon_c,
            re.S,
        )
        assert m, name
        body = re.sub(r"/\*.*?\*/", "", m.group(1))
        body = re.sub(r"//.*", "", body)
        return [int(x, 0) for x in re.findall(r"0x[0-9a-fA-F]+|\d+", body)]

    gmb = grab("falcon_GMb_16")
    igmb = grab("falcon_iGMb_16")
    ntt_in = grab("falcon_ntt_input")
    ntt_out = grab("falcon_ntt_output")
    intt_in = grab("falcon_intt_input")
    intt_out = grab("falcon_intt_output")
    _write(
        OUT_DIR / "vectors_falcon.py",
        "'''Auto-generated from falcon-ntt/falcon.c.'''\n\n"
        f"FALCON_N = 16\n"
        f"FALCON_Q = 12289\n"
        f"FALCON_R = 4091\n"
        f"FALCON_GMB_16 = {gmb!r}\n"
        f"FALCON_IGMB_16 = {igmb!r}\n"
        f"FALCON_NTT_INPUT = {ntt_in!r}\n"
        f"FALCON_NTT_OUTPUT = {ntt_out!r}\n"
        f"FALCON_INTT_INPUT = {intt_in!r}\n"
        f"FALCON_INTT_OUTPUT = {intt_out!r}\n",
    )


def gen_fpr() -> None:
    text = (HORCRUX_TESTS / "falcon-fpr/main.c").read_text(encoding="utf-8")
    entries = re.findall(
        r"\{(-?\d+)\s*,\s*(-?\d+)\s*,\s*(0x[0-9A-Fa-f]+)ULL\s*,\s*(0x[0-9A-Fa-f]+)ULL\}",
        text,
    )
    seen = set()
    rows = []
    for s, e, m, exp in entries:
        key = (s, e, m)
        if key in seen:
            continue
        seen.add(key)
        mi = int(m, 16)
        rows.append((int(s), int(e), mi, int(exp, 16)))
    body = ",\n    ".join(f"({s}, {e}, {m}, {exp})" for s, e, m, exp in rows)
    _write(
        OUT_DIR / "vectors_fpr.py",
        f'"""Auto-generated from falcon-fpr/main.c (unique vectors)."""\n\n'
        f"FPR_TESTS = [\n    {body},\n]\n",
    )


def gen_fpr_norm64() -> None:
    text = (HORCRUX_TESTS / "falcon-fpr-norm/main.c").read_text(encoding="utf-8")
    entries = re.findall(
        r"\{(0x[0-9A-Fa-f]+ULL)\s*,\s*(-?\d+)\s*,\s*(0x[0-9A-Fa-f]+ULL)\s*,\s*(-?\d+)\}",
        text,
    )
    seen = set()
    rows = []
    for m, e, em, ee in entries:
        key = (m, e)
        if key in seen:
            continue
        seen.add(key)
        mi = int(m.replace("ULL", ""), 16)
        emi = int(em.replace("ULL", ""), 16)
        rows.append((mi, int(e), emi, int(ee)))
    body = ",\n    ".join(f"({m}, {e}, {em}, {ee})" for m, e, em, ee in rows)
    _write(
        OUT_DIR / "vectors_fpr_norm64.py",
        f'"""Auto-generated from falcon-fpr-norm/main.c (unique vectors)."""\n\n'
        f"FPR_NORM64_TESTS = [\n    {body},\n]\n",
    )


def gen_thash_wots() -> None:
    variants = [
        ("SPHINCS+-128f-robust", 16, 0),
        ("SPHINCS+-128f-simple", 16, 1),
        ("SPHINCS+-192f-robust", 24, 0),
        ("SPHINCS+-192f-simple", 24, 1),
        ("SPHINCS+-256f-robust", 32, 0),
        ("SPHINCS+-256f-simple", 32, 1),
    ]
    cases = []
    chain_steps = 15
    spx_offset_chain = 27
    spx_offset_hash = 31
    for name, n, simple in variants:
        pub_seed = spx_fill_bytes(n, 0xA000 + n + simple * 5)
        addr = bytearray(spx_fill_bytes(SPX_ADDR_BYTES, 0xB000 + n + simple * 7))
        payload = spx_fill_bytes(n, 0xC000 + n + simple * 11)
        thash_out = spx_ref_thash(payload, pub_seed, bytes(addr), n, simple)
        cases.append(
            {
                "name": f"{name}-thash1",
                "n": n,
                "simple_mode": simple,
                "funct7": thash_funct7_for_n(n),
                "pub_seed": pub_seed,
                "addr": bytes(addr),
                "payload": payload,
                "expected": thash_out,
            }
        )

        pub_seed2 = spx_fill_bytes(n, 0xD000 + n + simple * 17)
        addr2 = bytearray(spx_fill_bytes(SPX_ADDR_BYTES, 0xE000 + n + simple * 19))
        state_init = bytearray(spx_fill_bytes(n, 0xF000 + n + simple * 23))
        state = bytearray(state_init)
        addr2[spx_offset_chain] = 3
        for i in range(chain_steps):
            addr2[spx_offset_hash] = i
            state = bytearray(
                spx_ref_thash(bytes(state), pub_seed2, bytes(addr2), n, simple)
            )
        cases.append(
            {
                "name": f"{name}-wots-chain",
                "n": n,
                "simple_mode": simple,
                "funct7": thash_funct7_for_n(n),
                "pub_seed": pub_seed2,
                "addr": bytes(addr2),
                "payload": bytes(state_init),
                "chain_steps": chain_steps,
                "expected": bytes(state),
            }
        )

    lines = ["'''Auto-generated thash-wots golden vectors.'''", "", "THASH_WOTS_CASES = ["]
    for case in cases:
        lines.append("    {")
        lines.append(f'        "name": {case["name"]!r},')
        lines.append(f'        "n": {case["n"]},')
        lines.append(f'        "simple_mode": {case["simple_mode"]},')
        lines.append(f'        "funct7": {case["funct7"]},')
        lines.append(f'        "pub_seed": {case["pub_seed"]!r},')
        lines.append(f'        "addr": {case["addr"]!r},')
        lines.append(f'        "payload": {case["payload"]!r},')
        if "chain_steps" in case:
            lines.append(f'        "chain_steps": {case["chain_steps"]},')
        lines.append(f'        "expected": {case["expected"]!r},')
        lines.append("    },")
    lines.append("]")
    _write(OUT_DIR / "vectors_thash_wots.py", "\n".join(lines) + "\n")


def gen_sha3_512() -> None:
    expected = hashlib.sha3_512(b"abc").digest()
    hexes = ", ".join(f"0x{b:02x}" for b in expected)
    _write(
        OUT_DIR / "vectors_sha3_512.py",
        '"""SHA3-512 single-block golden (keccak-abs coverage)."""\n\n'
        f"SHA3_512_ABC_EXPECTED = bytes([{hexes}])\n",
    )


def main() -> None:
    _parse_cbd(HORCRUX_TESTS / "cbd_eta3/main.c", "d_inputs", "golden", 5)
    _parse_cbd(HORCRUX_TESTS / "cbd_eta4/main.c", "d_eta4", "golden_eta4", 4)
    gen_mldsa_rej_uniform()
    gen_mldsa_rej_eta()
    gen_mldsa_unpack_z()
    gen_falcon()
    gen_fpr()
    gen_fpr_norm64()
    gen_thash_wots()
    gen_sha3_512()


if __name__ == "__main__":
    main()
