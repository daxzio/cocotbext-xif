# Icarus: `test_horcrux.test_thash1` hang (local debug ledger)

**Status:** open — do **not** enable root `make sim SIM=icarus` or a dedicated Icarus XIF CI workflow until this is fixed.

## Symptom

| | |
|---|---|
| **Test** | `tests/test_horcrux` · `test_dut.test_thash1` |
| **Simulator** | Icarus 13.0 · sv2v flat netlist `horcrux_xif_wrapper.v` |
| **Verilator** | PASS · ~3700 ns sim · case 1 ~0.15 s wall |

On Icarus it **looks** like a cocotb timeout on “issue id=9”, but that is misleading.

1. **Before monitor fix:** sim time often **stalled at ~1380 ns** (last LOAD handshake, monitor log “Issue id=9”). With a huge `timeout_max`, the run sits until the job is killed — not a clean `TimeoutError`.
2. **After `XifMonitor` fix:** loads complete; **Issue id=10** (THASH `0x6000703b`) at **1500 ns**, then sim time **never advances** (tested 10+ minutes wall).

So this is a **vvp freeze**, not slow THASH or `issue_ready` polling.

## What passes on Icarus (same sv2v netlist)

- `test_keccak_sha3_256_abc`, `test_chain_lengths` (many LOADs)
- Other horcrux suites except THASH/SPHINCS+ heavy paths (not fully swept)

## Case geometry (THASH1 case 1)

- `KINIT` + **8 LOAD pairs** (16 B pub_seed + 32 B addr + 16 B payload) → issue ids **2–9**
- **THASH** → id **10** (`funct7=48` / `0x6000703b`)
- **KSTORE** reads → ids 11–14 (Verilator only today)

Freeze point: **first cycle of / immediately after THASH issue accept**, not the 8th LOAD by itself.

## Fixes already in tree (local)

### 1. `XifMonitor` + Icarus VPI (`cocotbext/xif/xif_monitor.py`)

The old `_resolve_signals` coroutine sampled **every** bus signal every clock via VPI on the sv2v netlist. That could stall vvp around the last LOAD (looked like “hang on id=9”).

**Fix:** remove the parallel resolver; after each `RisingEdge`, `ReadOnly()`, then `_sample_bus()` inside `_run()`.

### 2. `id_stage.sv` (`tests/rtl/horcrux/.../id_stage.sv`)

`rd_o` / `id_o` used `<=` inside `always_comb` — changed to blocking `=`. Regenerate Icarus netlist:

```bash
cd tests/test_horcrux && make sv2v
```

Correct SV; **did not** fix the THASH freeze.

### 3. Test debug env (optional, `tests/test_horcrux/test_dut.py`)

| Variable | Purpose |
|----------|---------|
| `HORCRUX_THASH1_ONE_CASE=1` | First vector only |
| `HORCRUX_XIF_TIMEOUT_MAX` | Override `XifHost.timeout_max` |
| `HORCRUX_NO_MONITOR=1` | Skip monitor (mostly obsolete after monitor fix) |
| `HORCRUX_LOAD_DEBUG=1` | Log each LOAD pair |

## Likely root cause (THASH path)

Multi-cycle **SPHINCS+ / `sphincs_ops`** + **Keccak** after THASH is accepted. Suspects on Icarus/sv2v only:

- Combinational mux `keccak_input` between `register_array_flat` (large sv2v concat) and `sphincs_keccak_input` when `sphincs_active` asserts
- Iverilog delta-cycle / comb loop when FSM leaves IDLE for THASH (`ABSORB_1` / `WAIT_1` paths in `sphincs_ops.sv`)

VPI noise: `Unable to create sv2v_cast_32 via any registered implementation` at startup — separate from the freeze; cocotb substitutes zeros for some reads.

## Repro

```bash
source ~/.venv/horcrux-3.13.5/bin/activate
cd tests/test_horcrux
HORCRUX_THASH1_ONE_CASE=1 COCOTB_TESTCASE=test_thash1 make sim SIM=icarus
# Expect stall after "Issue id=10" or load debug "issuing thash funct7=48"
```

Verilator control:

```bash
WAVES=0 HORCRUX_THASH1_ONE_CASE=1 COCOTB_TESTCASE=test_thash1 make sim SIM=verilator
```

## Next steps (when resuming)

1. `$display` / small vvp-only TB on first posedge after THASH accept — confirm `sphincs_active`, `state_q`, `keccak_input` mux.
2. Try registered `keccak_input` (one cycle) in vendored `horcrux.sv` for Icarus bring-up.
3. Bisect `sphincs_ops.sv` always_comb vs Verilator wave at 1500–1600 ns.
4. Until fixed: **exclude** `test_thash1`, `test_thash2`, `test_prf_addr` from any future Icarus CI matrix (or run horcrux with `COCOTB_TEST_FILTER` negation).

## CI policy

| Workflow | Ship? |
|----------|--------|
| `test_xif_verilator.yml` | yes |
| `test_xif_xezim.yml` | yes (side-by-side with Verilator) |
| Full-suite Icarus `make sim SIM=icarus` | **no** until THASH hang is fixed |