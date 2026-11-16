# RDL-driven APB front-end flow (prototype)

Project-level notes for a reusable **SystemRDL → PeakRDL-etana → APB4 → cocotb** flow.
The reference implementation lives in `tests/test_horcrux_apb/`: a PeakRDL-generated
register block controls an accelerator core over APB, with thin hand-written glue
(sequencer + optional instruction predecoder) between the CSR outputs and the core ports.

The goal is to grow this into a general pattern (RDL as the single source of truth
for software, documentation, and RTL) rather than bespoke bus adapters per block.

---

## Reference implementation

**Suite directory:** `tests/test_horcrux_apb/`

### File layout

| File | Role |
|------|------|
| `horcrux_regs.rdl` | SystemRDL addrmap (register map, field semantics) |
| `regblock_udps.rdl` | Field UDPs (`wr_swacc`, `rd_swacc`) for etana strobes |
| `makefile_rdl.mak` | RDL → RTL generation recipe (`make etana`) |
| `horcrux_regs_apb4.sv` | **Generated** APB4-flat CSR RTL (commit after regen) |
| `horcrux_regs_apb4_hwif.rpt` / `.csv` | Generated hwif report (optional reference) |
| `horcrux_cmd_seq.sv` | Command sequencer (issue pulse, FSM, result capture) |
| `horcrux_instr_decode.sv` | Optional 32-bit instruction → core opcode predecoder |
| `horcrux_apb_wrapper.sv` | Top: CSR + glue + core instance |
| `horcrux_apb_host.py` | cocotb APB driver (`execute`, `issue_instr`, …) |
| `horcrux_opcodes.py` | Core opcode constants for direct `CMD.OPCODE` writes |
| `test_dut.py` | cocotb tests (vectors imported from `tests/test_horcrux/`) |
| `Makefile` | sim (Verilator / Icarus+sv2v), synth includes |
| `makefile_synth.mak` / `makefile_synth_local.mak` | Vivado OOC utilization flow |
| `constraints/clk.xdc` | 100 MHz clock for synth |

External compute RTL comes from `$(HORCRUX_DIR)` (default `~/projects/horcrux`).
Only packages needed by the core are compiled; no CPU pipeline blocks are in this build.

---

## Block diagram

```
  s_apb_*  ──►  horcrux_regs_apb4  ──►  o_rs1/rs2/rs3, wr_swacc strobes
                      ▲                      │
                      │ i_status, i_rd1       ▼
                      │               horcrux_cmd_seq
                      │                      │
                      │         (optional) horcrux_instr_decode
                      │                      │
                      └──────────────────────┴──► horcrux (core)
```

Software sees a flat register map. Hardware sees operand registers, a one-shot
issue strobe on `CMD` or `INSTR`, status, and a read-only result register.

---

## Register map (`horcrux_regs.rdl`)

Byte offsets, 32-bit regwidth:

| Offset | Register | SW | HW | Notes |
|--------|----------|----|----|-------|
| `0x00` | `RS1.VALUE` | rw | r | Operand 0 |
| `0x04` | `RS2.VALUE` | rw | r | Operand 1 |
| `0x08` | `RS3.VALUE` | rw | r | Operand 2 |
| `0x0C` | `CMD.OPCODE[6:0]` | rw | r | **`wr_swacc`**: write strobe = issue (direct 7-bit opcode) |
| `0x10` | `INSTR.VALUE` | rw | r | **`wr_swacc`**: issue via 32-bit instruction alias |
| `0x14` | `STATUS` | mixed | w | `BUSY[0]` ro, `DONE[1]` sticky + `woclr`, `ACCEPT[2]` ro |
| `0x18` | `RD1.VALUE` | ro | w | Result word |

### Field UDPs

Copied from hazard3 (`regblock_udps.rdl`):

- **`wr_swacc`** — pulse when SW writes the field (used for command issue).
- **`rd_swacc`** — pulse on SW read (not used here yet; pattern for FIFO pop).

Generated etana exports `o_*_wr_swacc` strobes. Qualify with `s_apb_penable` in
the wrapper so each APB access fires exactly once (etana asserts strobes for the
whole PSEL window; see hazard3 `spi_host_apb.sv`).

---

## RDL → RTL generation

**Tool:** [PeakRDL-etana](https://github.com/daxzio/PeakRDL-etana) (`peakrdl etana`).

**Makefile convention:**

- Recipe file: `makefile_rdl.mak` (`.mak` suffix for editor highlighting).
- Target name: **`make etana`** — runs `peakrdl etana`.
- Target name **`regblock`** is **reserved** for a future `peakrdl regblock` flow
  (upstream PeakRDL-regblock, different generator / port naming).

```bash
source ~/.venv/hulkv2-3.13.5/bin/activate   # has peakrdl-etana, cocotbext-apb
cd tests/test_horcrux_apb
make etana
```

Generation flags (in `tests/test_horcrux_apb/makefile_rdl.mak`):

```make
peakrdl etana regblock_udps.rdl horcrux_regs.rdl \
  --top HORCRUX_REGS --rename horcrux_regs_apb4 \
  --cpuif apb4-flat -o . \
  --in-str i --out-str o --default-reset arst_n \
  --flatten-nested-blocks --hwif-report
```

Commit `horcrux_regs_apb4.sv` after regen so sim/synth do not require etana on
every run.

---

## Glue RTL (hand-written)

### Sequencer (`horcrux_cmd_seq.sv`)

Drives the core boundary:

- **`insn_o`** — 1-cycle registered pulse per issue.
- **`rs_values_o`** — operands for exactly one cycle (same timing as core expects).
- **`start_keccak_o`** — combinatorial decode of registered insn
  (`OP_KSTART` / `OP_KPERM`).
- **FSM** — `IDLE` / `WAIT_KECCAK` / `WAIT_SPHINCS`; `done_pulse_o` when the op
  completes; capture `RD1` on done.
- **Status** — `busy_o`, `accept_o` (only accept new issues in `IDLE`).

Uses a one-cycle `state_keccak` / `state_sphincs` flag before entering wait
states.

### Optional predecoder (`horcrux_instr_decode.sv`)

When `EnableInstrDecode=1`, a write to `INSTR` can carry a raw 32-bit custom
instruction; the predecoder walks `horcrux_pkg::CoproInstr[]` and produces the
7-bit core opcode. When `EnableInstrDecode=0`, only `CMD.OPCODE` is used (smaller
synth footprint).

Wrapper parameter: `EnableInstrDecode` (default `1` in sim, override for synth).

### Critical timing fix

On the issue cycle, **decode `s_apb_pwdata`**, not the post-write CSR export.
PeakRDL updates field storage on the clock edge; `wr_swacc` fires during the
access phase with the new write data still on `pwdata`:

```systemverilog
assign decode_instr_word = instr_issue ? s_apb_pwdata : o_instr_value;
assign cmd_opcode_sel    = cmd_issue   ? s_apb_pwdata[6:0] : o_cmd_opcode;
assign issue_pulse       = (o_cmd_opcode_wr_swacc | o_instr_value_wr_swacc)
                           && s_apb_penable;
```

---

## Software / cocotb usage

**Driver:** `horcrux_apb_host.py` + `cocotbext.apb` (`ApbBus.from_prefix(dut, "s_apb")`).

Typical blocking flow (`execute_instr`):

1. Wait idle (`STATUS.BUSY == 0`).
2. Clear sticky done (`write STATUS` with `DONE` bit for `woclr`).
3. Write `RS1`, `RS2`, `RS3`.
4. Write `INSTR` (or `CMD`) — **`wr_swacc` issues the op**.
5. Poll `STATUS.DONE`.
6. Read `RD1`.

For multi-cycle Keccak sequences, use `issue_instr()` (no done wait) plus explicit
idle cycles — same pattern as pushing bytes to a FIFO without per-byte handshakes.

**Two issue modes:**

| Mode | Register | When to use |
|------|----------|-------------|
| Instruction alias | `INSTR` | Encoded 32-bit custom insn (needs `EnableInstrDecode=1`) |
| Direct opcode | `CMD.OPCODE[6:0]` | Known 7-bit core enum (`horcrux_opcodes.py`) |

Tests reuse golden vectors from `tests/test_horcrux/` via `PYTHONPATH`; only the
bus driver changes.

---

## Simulation

**Venv:** `~/.venv/hulkv2-3.13.5` (cocotb 2.0.1, cocotbext-apb, peakrdl-etana).

```bash
source ~/.venv/hulkv2-3.13.5/bin/activate
cd tests/test_horcrux_apb

# Verilator (SystemVerilog direct)
make sim SIM=verilator WAVES=0

# Icarus (sv2v netlist)
make sv2v
make sim SIM=icarus WAVES=0
```

Icarus builds from a single converted `horcrux_apb_wrapper.v`; regenerate with
`make sv2v` after RTL changes.

---

## Synthesis (utilization only)

Shared flow under `tests/rtlflo/` (`vivado_build`, `vivado_synth`, `VIVADO_TO_STEP=route_design`).

```bash
source ~/.venv/horcrux-3.13.5/bin/activate   # pyfpga / Vivado helpers
cd tests/test_horcrux_apb
make vivado_build XILINX_GENERICS="EnableInstrDecode=0"   # or =1
make vivado_synth
```

Part: `xc7a100tcsg324-1` (Artix-7 100T). Reports under `tests/test_horcrux_apb/build-2025.1/`.

Example post-route (OOC):

| Config | LUT | FF | DSP |
|--------|-----|-----|-----|
| `EnableInstrDecode=0` | 22,615 | 4,724 | 11 |
| `EnableInstrDecode=1` | 22,693 | 4,711 | 11 |

CSR block (`horcrux_regs_apb4`) is ~240 LUT; bulk is the compute core.

---

## Makefile naming conventions (for future blocks)

Per-suite files under `tests/test_<block>/`:

| File | Purpose |
|------|---------|
| `makefile_rdl.mak` | PeakRDL **etana** generation (`make etana`) |
| `makefile_rdl.mak` | (later) add `regblock:` target → `peakrdl regblock` |
| `makefile_synth.mak` | Vivado defaults |
| `makefile_synth_local.mak` | Part, constraints, OOC, generics |
| `Makefile` | cocotb sim, `sv2v`, includes above |

Keep **`etana`** and **`regblock`** as distinct target names even if both live in
`makefile_rdl.mak`.

---

## Future work (flow development)

Ideas to generalise beyond the Horcrux reference:

1. **RDL `external mem`** for large accelerator state (e.g. Keccak sponge) instead
   of per-word custom opcodes — major throughput win for streaming workloads.
2. **C header / Rust / Python reggen** from the same RDL (`peakrdl c-header`, etc.).
3. **Native OBI** variant (`--cpuif obi-flat`) for blocks already on Open Bus Interface.
4. **Automated `wr_swacc` + `penable` gating** as a small reusable APB adapter shell.
5. **Template directory** — copy `makefile_rdl.mak`, `regblock_udps.rdl`, wrapper
   skeleton, and cocotb `ApbHost` pattern for new accelerators.
6. **`peakrdl regblock` path** — compare generated RTL and port naming against etana
   when integrating with blocks that already use upstream regblock.
7. **Interrupts** — `DONE` as level/sticky IRQ via RDL `intr` fields instead of polling.
8. **Remove block-specific coupling** — opcode predecoder table lives in core package
   today; could move decode tables into RDL user-defined properties or a sidecar file.

---

## References in other trees

- hazard3 RDL/Makefile: `/mnt/sda/projects/daxzio-hazard3/rdl/`
- SPI host APB `wr_swacc` + `penable` pattern: `daxzio-hazard3/rtl/spi_host/spi_host_apb.sv`
- cocotbext-apb examples: `/mnt/sda/projects/cocotbext-apb/tests/test_basic/`
