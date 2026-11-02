# Verilator 5.052 and 5.054 run out of memory elaborating Ara

Do not start `make sim SIM=verilator` against Verilator 5.052 or later in this directory. It does not print an error. `ConstVisitor` recurses down a deep expression, the C stack grows without a bound, and the process fills RAM.

## What is pinned

`tests/test_ara/Makefile` sets `VERILATOR_BIN_DIR` to the spack 5.050 bin before the cocotb rules are included, and errors if that tree is missing. `make sim SIM=verilator` in this directory does not follow `PATH`.

```text
/cadtools/spack-2025/opt/linux-ubuntu24.04-skylake/gcc-13.3.0/verilator/5.050-dco5jf2a4yvqukp3yuesxjvxhywxoptd/bin
Verilator 5.050 2026-07-01 rev vUNKNOWN-built20260703
```

5.050 writes `Vtop.mk` in 26.4 s and reports 1690 MB allocated. The C stack stays about 2 MB.

`module load verilator` on this machine is **5.054** (2026-11-01, built 20261102):

```text
/cadtools/spack-2025/opt/linux-ubuntu24.04-skylake/gcc-13.3.0/verilator/5.054-vvcpckuje7dzimt7kpsvf3oxjpuqjdzj/bin/verilator
```

5.052 (2026-09-05) fails the same way. Both reach a heap plateau near 1.6 GB, then the `[stack]` mapping grows through multiple gigabytes until the process is killed. No `%Error`. No `Vtop.mk`.

The Perl wrapper calls `ulimit_stack_unlimited()` before `exec`, so the recursion is charged as RAM.

## Where it dies

A sample of `verilator_bin` during the stack growth is `ConstVisitor` on one deep expression:

- `ConstVisitor::visit(AstOr*)`
- `AstNode::iterateChildren` / `iterateAndNext`
- `ConstVisitor::visit(AstAnd*)`
- `ConstVisitor::visit(AstCCast*)`
- `ConstVisitor::visit(AstShiftR*)`
- `ConstVisitor::visit(AstAnd*)` → `match_And_1` → `V3Number::mostSetBitP1`

That walk is a const-before-DFG pass. `-fno-const` leaves `fConstBeforeDfg` set, and the stack still climbs. `V3Expand` and the DFG passes run later.

This is not [#6561](https://github.com/verilator/verilator/issues/6561) (fixed before 5.050), not [#8363](https://github.com/verilator/verilator/issues/8363) (huge `Syms__Slow.cpp` after a successful elaborate), and not [#8272](https://github.com/verilator/verilator/pull/8272) / [#8308](https://github.com/verilator/verilator/pull/8308) (already in 5.054). [#5865](https://github.com/verilator/verilator/issues/5865) nests and/or enables on one side and is a suspect for the spine. The sampled parents also include a shift and a cast, so that change is not proven to be the whole regression. There is no reduced test: a hand-nested `|` chain dies in the parser on both 5.050 and 5.054.

No GitHub issue is filed yet. Draft title: "Out of memory: ConstVisitor recurses on a deep expression (regression in 5.052)". Verilator's template asks for a self-contained example, which this note does not have.

## What not to do

- Do not `module load verilator` and then `make sim SIM=verilator` here.
- Do not delete the `VERILATOR_BIN_DIR` pin.
- Do not pass `WAVES=1` while investigating this. The untraced elaboration is already enough to swap a 32 GB machine.
- Do not treat a missing `%Error` as a hang to wait out. Kill `verilator_bin` if RSS climbs through several gigabytes before `Vtop.mk` exists. Prefer a cgroup `MemoryMax` with `MemorySwapMax=0`.

Confirm the pin without launching Verilator:

```bash
cd /mnt/sda/projects/cocotbext-xif/tests/test_ara
make -qp SIM=verilator WAVES=0 | grep '^VERILATOR_BIN_DIR'
```

## Separate from this

[aionhw/xezim#527](https://github.com/aionhw/xezim/issues/527) (named `begin : exception` in `vstu.sv`) was closed on 2026-10-26. It is not this Verilator failure.
