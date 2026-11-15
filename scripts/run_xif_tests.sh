#!/usr/bin/env bash
# Run all cocotb XIF suites from the repo root.
#
# Verilator (default) or Icarus (sv2v runs automatically when SIM=icarus):
#   source ~/.venv/horcrux-3.13.5/bin/activate
#   ./scripts/run_xif_tests.sh
#   ./scripts/run_xif_tests.sh icarus
#
# xezim:
#   module load xezim/0.11.6
#   source ~/.venv/xezim-3.14.5/bin/activate
#   ./scripts/run_xif_tests.sh xezim
#
# Optional env: WAVES=0|1, XEZIM_MAX_TIME=60s, XEZIM_BIN=/path/to/xezim
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SIM="${1:-verilator}"
WAVES="${WAVES:-0}"

cd "$ROOT"
make sim "SIM=${SIM}" "WAVES=${WAVES}"