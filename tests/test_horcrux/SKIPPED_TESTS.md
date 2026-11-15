# Horcrux cocotb — skipped / blocked tests

Reference: upstream suite in `~/projects/horcrux/sw/applications/tests/run_tests.sh`.

Full suite today: **46 cocotb tests — 44 PASS, 2 SKIP** (`make sim SIM=verilator WAVES=0`).

---

## Cocotb skips (`@cocotb.test(skip=True)`)

### 1. `test_falcon_montg` (`test_dut.py`)

| | |
|---|---|
| **Upstream** | `falcon-montg` |
| **Intent** | Scalar Falcon Montgomery **reduction** mod `q = 12289`: wide 32-bit `a` → 16-bit result (20 vectors). |
| **SW golden** | `montgomery_reduce_falcon()` in `falcon-montg/main.c` |
| **Why skipped** | Upstream HW still emits **`funct7 = 0x02`**, which current RTL decodes as **`OP_STORE`** (Keccak register-file store), not Montgomery reduce. There is no standalone “Falcon montg” opcode in today’s map that matches that asm. |
| **Cocotb workaround tried** | `FUNCT7_MQMULF` (`OP_MQMULF`, Montgomery **multiply**) with `rs2 = 1` — wrong operation vs reduce; goldens would not match. |
| **Related coverage** | `test_mq_montymul` (MQMULF multiply), `test_falcon_ntt` / `test_falcon_intt` (Montgomery fused in butterflies). |
| **To unblock** | Fix upstream `MONTG_FALCON` asm to a real RTL opcode, or add/document a dedicated reduce op; then point cocotb at it (not MQMULF). |

Upstream asm (stale):

```c
.insn r 0x3b, 0x7, 0x2, ...   /* funct7=0x02 → OP_STORE in horcrux_pkg.sv */
```

Vectors: `tests/test_horcrux/vectors.py` → `FALCON_MONTG_TESTS`.

---

### 2. `test_mldsa_rej_eta4` (`test_dut_remaining.py`)

| | |
|---|---|
| **Upstream** | `mldsa-rej-eta` (partial) |
| **Intent** | ML-DSA nibble rejection for **η = 4**: `OP_REJ_ETA4` (`funct7 = 0x4A`), coeffs in **[-4, +4]**. |
| **SW golden** | `rej_eta4_sw()` in `mldsa-rej-eta/main.c` (100 cases: 50 bytes × 2 nibble selectors). |
| **Why skipped** | Upstream **`main.c` only runs HW for `OP_REJ_ETA2` (`0x49`)**. The η=4 path is SW reference only; no upstream HW asm block to validate against. Cocotb had a failing HW run when enabled — needs joint review with upstream before trusting RTL or goldens. |
| **Related coverage** | `test_mldsa_rej_eta2` (PASS, same file, HW path exercised upstream). |
| **To unblock** | Add η=4 HW tests upstream (or confirm RTL + cocotb goldens); re-enable and debug if still failing. |

Vectors: `tests/test_horcrux/vectors_mldsa_rej_eta.py` → `REJ_ETA4_TESTS` (generated; ready when unskipped).

---

## Not migrated (no cocotb test)

### 3. `sampler-test`

| | |
|---|---|
| **Upstream** | Listed in `run_tests.sh` |
| **Why no test** | **`sampler-test/` directory is missing** in the horcrux checkout used here — nothing to port. |
| **RTL note** | `sampler.sv` is in the Horcrux build (`Makefile`); opcode exists in RTL. |
| **To unblock** | Restore or obtain upstream `sampler-test` app; add vectors + cocotb test. |

---

## Quick index

| Item | Cocotb | Status |
|------|--------|--------|
| `falcon-montg` | `test_falcon_montg` | SKIP — opcode mismatch |
| `mldsa-rej-eta` (η=4 HW) | `test_mldsa_rej_eta4` | SKIP — no upstream HW reference |
| `sampler-test` | — | Not migrated — missing upstream tree |

When revisiting, start with upstream `main.c` / `horcrux_pkg.sv` opcode tables, then re-run the single test:

```bash
source ~/.venv/horcrux-3.13.5/bin/activate
cd tests/test_horcrux
make sim SIM=verilator WAVES=0 COCOTB_TESTCASE=test_falcon_montg
make sim SIM=verilator WAVES=0 COCOTB_TESTCASE=test_mldsa_rej_eta4
```
