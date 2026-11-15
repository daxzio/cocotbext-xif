#!/usr/bin/env bash
# Refresh vendored RTL under tests/rtl for CI and offline sim.
# Safe to re-run; does not delete unrelated trees.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RTL="$ROOT/tests/rtl"

# --- Ara (full hardware tree + Bender deps for Verilator) ---
if [[ -L "$RTL/ara" ]]; then
    rm "$RTL/ara"
fi
ARA_SRC="${ARA_SRC:-$RTL/ara.bck}"
if [[ ! -d "$ARA_SRC/hardware" ]]; then
    echo "Missing Ara vendor source: $ARA_SRC (set ARA_SRC)" >&2
    exit 1
fi
mkdir -p "$RTL/ara"
rsync -a --delete \
    --exclude .git \
    --exclude toolchain \
    "$ARA_SRC/" "$RTL/ara/"

# --- Minimal bus / cell slices used by tests/test_ara/Makefile ---
for slice in axi common_cells fpu_div_sqrt_mvp tech_cells_generic common_verification; do
    src_bck="$RTL/${slice}.bck"
    src_plain="$RTL/$slice"
    if [[ -d "$src_bck" ]]; then
        echo "Sync $slice from ${slice}.bck"
        mkdir -p "$src_plain"
        rsync -a --delete --exclude .git "$src_bck/" "$src_plain/"
    fi
done

# --- Minimal CVA6 slice (Ara accelerator types + serdiv only) ---
CVA6_SRC="${CVA6_SRC:-$HOME/projects/cva6}"
CVA6_MIN="$RTL/cva6"
if [[ ! -d "$CVA6_SRC/core/include" ]]; then
    echo "Missing CVA6_SRC: $CVA6_SRC" >&2
    exit 1
fi
rm -rf "$CVA6_MIN"
mkdir -p "$CVA6_MIN/include"
for f in \
    config_pkg.sv \
    cv64a6_imafdcv_sv39_config_pkg.sv \
    riscv_pkg.sv \
    ariane_pkg.sv \
    build_config_pkg.sv
do
    cp "$CVA6_SRC/core/include/$f" "$CVA6_MIN/include/"
done
cp "$CVA6_SRC/core/serdiv.sv" "$CVA6_MIN/"

# --- HORCRUX (coprocessor + CV32 XIF packages only) ---
HORCRUX_SRC="${HORCRUX_SRC:-$HOME/projects/horcrux}"
if [[ ! -d "$HORCRUX_SRC/hw/ip/coprocessors" ]]; then
    echo "Missing HORCRUX_SRC: $HORCRUX_SRC" >&2
    exit 1
fi
mkdir -p "$RTL/horcrux/hw"
rsync -a --delete --exclude .git \
    "$HORCRUX_SRC/hw/ip/" "$RTL/horcrux/hw/ip/"
rsync -a --delete --exclude .git \
    "$HORCRUX_SRC/hw/vendor/" "$RTL/horcrux/hw/vendor/"

echo "Vendored RTL under $RTL (ara, horcrux, dependency slices)."