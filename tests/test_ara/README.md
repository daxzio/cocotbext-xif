# Test: PULP Ara vector unit (XIF at top level)

Only the coprocessor is instantiated, with **XIF at the top** (issue, commit, result, mem). File list, include dirs, and defines are **explicit in the Makefile** (no generated .mak).

- **Top**: `ara_xif_wrapper` → **ara_xif_core** (XIF→acc bridge + **ara** + axi_zero_mem).
- **RTL**: `../rtl/ara` (Ara repo; run `make checkout` and `make apply-patches` in `ara/hardware` once).

## One-time setup

From the repo root, fetch pulp AXI / common_cells / tech_cells sources (not stored in git):

```bash
bash scripts/fetch_test_ara_rtl.sh
```

Optionally, in `tests/rtl/ara/hardware`: run `make checkout` and `make apply-patches` for a full Ara hardware tree.

## Verilator version

Use **Verilator 5.050**. The Makefile sets `VERILATOR_BIN_DIR` to the spack 5.050 install, so `make sim SIM=verilator` does not follow whatever `verilator` is on `PATH`.

**5.052 and 5.054 are not usable for this test.** `module load verilator` is 5.054 (2026-11-01). Elaborating Ara sits in `verilator_bin` after the AST is built: `ConstVisitor` recurses down a deep expression and the C stack grows until the process is killed. There is no `%Error` and no `Vtop.mk`. 5.050 finishes the same elaborate at about 1.7 GB with a 2 MB stack. This is not [verilator#6561](https://github.com/verilator/verilator/issues/6561) and not the DFG passes. Full note: [VERILATOR-5.052.md](VERILATOR-5.052.md).

Keep `WAVES=0`. `WAVES=1` adds `--trace --trace-fst --trace-structs` on top of that elaboration.

## Run

From `tests/test_ara`: `make sim` (with venv activated). Builds the explicit RTL list in the Makefile and runs **test_ara_smoke**, **test_ara_xif_ready**, **test_ara_vsetvli**, **test_ara_vsetivli**, and **test_ara_vsetvl**. On **`SIM=xezim`**, **test_ara_vsetvli** and **test_ara_vsetvl** are skipped until XIF result writeback matches Verilator (the other three tests still run). `xif_helpers.py` in this directory is a symlink to `tests/xif_helpers.py`. Verilator build uses parallel C++ jobs and no trace by default; use `WAVES=1` for a waveform dump. After a successful build, `make retest SIM=verilator` re-runs the tests without recompiling.

## Icarus (sv2v + iverilog)

Icarus does not support full SystemVerilog, so the design is converted to plain Verilog with **sv2v** first:

1. **`make sv2v`** — converts Ara + deps to a single `ara_xif_wrapper.v`, then runs `post_sv2v_icarus.py`. Defaults to the local sv2v with enum-method support (`SV2V=/mnt/sda/projects/sv2v/bin/sv2v`). Defines `VERILATOR` so AXI assertion blocks are stripped. Patches `ara_req.emul.next()` via a sed copy (`ara_dispatcher_sv2v.sv`) until sv2v can rewrite enum methods on type-parameter fields.
2. **`make sim SIM=icarus`** — builds and runs with iverilog; uses only `ara_xif_wrapper.v` (no raw .sv). Run `make sv2v` before this if the .v file is missing or outdated.

Once `ara_xif_wrapper.v` exists, the Icarus path runs the full test set including **test_ara_vsetvli** (unlike Verilator, where that test is skipped).

## Hierarchy (instance + source file)

From `tests/test_ara`, run **`make hierarchy`** (requires Verilator). This runs `verilator --json-only` on the same RTL as the sim build, then prints a tab-separated table: **PATH**, **INSTANCE**, **MODULE**, **SOURCE_FILE** for the full Ara coprocessor hierarchy. Example:

```
make hierarchy
```

Output is to stdout; redirect to a file or pipe to `column -t -s $'\t'` for aligned columns. Module names in the JSON are elaborated (e.g. with `__pi*` parameter suffixes).

## Makefile layout

- **VERILOG_INCLUDE_DIRS**: common_cells, axi, cva6 util + core/include, ara include.
- **DEFINES**: NR_LANES=2, VLEN=128, ARIANE_ACCELERATOR_PORT=1, COMMON_CELLS_ASSERTS_OFF.
- **Sources**: CVA6 config + serdiv + stubs, AXI (axi_pkg, axi_intf, axi_to_detailed_mem, axi_zero_mem), common_cells, tech_cells, fpnew + div_sqrt, Ara src + tb/ara_xif_core, ara_xif_wrapper.
