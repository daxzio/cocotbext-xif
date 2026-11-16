#!/usr/bin/env bash
# Populate pulp-platform RTL under tests/rtl/{axi,common_cells,tech_cells_generic}
# when only Bender metadata is vendored (no src/). Safe to re-run.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RTL="$ROOT/tests/rtl"

clone_if_missing() {
    local name="$1"
    local repo="$2"
    local ref="$3"
    local marker="$4"
    local dest="$RTL/$name"

    if [[ -f "$marker" ]]; then
        echo "fetch_test_ara_rtl: $name already present ($marker)"
        return 0
    fi

    echo "fetch_test_ara_rtl: cloning $name ($ref)..."
    local tmp
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' RETURN
    git -c advice.detachedHead=false clone --depth 1 --branch "$ref" "$repo" "$tmp/repo"
    mkdir -p "$dest"
    if [[ -d "$tmp/repo/src" ]]; then
        cp -a "$tmp/repo/src" "$dest/"
    fi
    if [[ -d "$tmp/repo/include" ]] && [[ ! -d "$dest/include" ]]; then
        cp -a "$tmp/repo/include" "$dest/"
    fi
    if [[ -d "$tmp/repo/hdl" ]]; then
        cp -a "$tmp/repo/hdl" "$dest/"
    fi
    if [[ -d "$tmp/repo/src/rtl" ]]; then
        mkdir -p "$dest/src"
        cp -a "$tmp/repo/src" "$dest/"
    fi
    rm -rf "$tmp"
    trap - RETURN

    if [[ ! -f "$marker" ]]; then
        echo "fetch_test_ara_rtl: expected $marker after clone of $name" >&2
        exit 1
    fi
    echo "fetch_test_ara_rtl: $name ready"
}

# Pin with tests/rtl/axi/VERSION when present; tags are v0.39.5 style on GitHub.
AXI_VER="$(cat "$RTL/axi/VERSION" 2>/dev/null || echo 0.39.5)"
clone_if_missing axi https://github.com/pulp-platform/axi.git "v${AXI_VER}" \
    "$RTL/axi/src/axi_pkg.sv"

clone_if_missing common_cells https://github.com/pulp-platform/common_cells.git v1.37.0 \
    "$RTL/common_cells/src/cf_math_pkg.sv"

# tc_sram_impl appears from v0.2.10; pin matches vendored Bender metadata under tests/rtl/tech_cells_generic.
clone_if_missing tech_cells_generic https://github.com/pulp-platform/tech_cells_generic.git v0.2.13 \
    "$RTL/tech_cells_generic/src/rtl/tc_sram.sv"