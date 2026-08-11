# CORE-V XIF interface modules for Cocotb

[![Build Status](https://github.com/daxzio/cocotbext-xif/actions/workflows/test_checkin.yml/badge.svg?branch=main)](https://github.com/daxzio/cocotbext-xif/actions/)
[![PyPI version](https://badge.fury.io/py/cocotbext-xif.svg)](https://pypi.org/project/cocotbext-xif)
[![Downloads](https://pepy.tech/badge/cocotbext-xif)](https://pepy.tech/project/cocotbext-xif)

GitHub repository: https://github.com/daxzio/cocotbext-xif

## Introduction

Simulation models for the [OpenHW Group CORE-V eXtension Interface (CV-X-IF / XIF)](https://docs.openhwgroup.org/projects/openhw-group-core-v-xif/) for use with [cocotb](https://github.com/cocotb/cocotb).

XIF lets a RISC-V CPU offload instructions to an external coprocessor over independent issue, memory, commit, and result channels. This package provides bus binding, a host-side driver, a monitor, and related helpers for building cocotb testbenches against XIF-attached DUTs.

Specification: [core-v-xif](https://github.com/openhwgroup/core-v-xif)

## Installation

Installation from pip (release version, stable):

    $ pip install cocotbext-xif

Installation from git (latest development version, potentially unstable):

    $ pip install https://github.com/daxzio/cocotbext-xif/archive/main.zip

Installation for active development:

    $ git clone https://github.com/daxzio/cocotbext-xif
    $ pip install -e cocotbext-xif

Runtime dependency: `cocotb`. The `Bus` helper is vendored in-tree (`cocotbext.xif.bus`); `cocotb-bus` is not required.

## Documentation and usage examples

See the `tests` directory for complete testbenches (`test_xif_copro`, `test_fpu_ss`, `test_ara`).

### XIF Bus

`XifBus` maps an XIF interface on the DUT. Class methods `from_entity` and `from_prefix` match signals by name (with an optional prefix such as `s_xif`).

```python
from cocotbext.xif import XifBus

bus = XifBus.from_prefix(dut, "s_xif")
```

#### Required signals (relative to prefix)

**Issue:** `issue_valid`, `issue_ready`, `issue_req_instr`, `issue_req_mode`, `issue_req_id`, `issue_req_rs_0`, `issue_req_rs_1`, `issue_req_rs_valid`, `issue_resp_accept`, `issue_resp_writeback`, `issue_resp_dualwrite`, `issue_resp_dualread`, `issue_resp_loadstore`, `issue_resp_exc`

**Memory:** `mem_valid`, `mem_ready`, `mem_req_id`, `mem_req_addr`, `mem_req_mode`, `mem_req_we`, `mem_req_size`, `mem_req_be`, `mem_req_wdata`, `mem_req_last`, `mem_resp_exc`, `mem_resp_exccode`, `mem_result_valid`, `mem_result_id`, `mem_result_rdata`, `mem_result_err`

**Commit:** `commit_valid`, `commit_id`, `commit_kill`

**Result:** `result_valid`, `result_ready`, `result_id`, `result_data`, `result_rd`, `result_we`, `result_exc`, `result_exccode`

#### Optional

`issue_req_ecs`, `issue_req_ecs_valid`, `mem_resp_dbg`, `mem_result_dbg`, `compressed_valid`, `compressed_req`

### XIF Host

`XifHost` is the preferred CPU/host-side driver. It issues instructions on the XIF, handles commit, and checks results.

```python
from cocotbext.xif import XifBus, XifHost

bus = XifBus.from_prefix(dut, "s_xif")
xif = XifHost(bus, dut.clk_i)

# Subclass to customize instruction encoding / expected result, then:
await xif.write_xx(rs0=0xDEADBEEF, expected_val=0xF77DB57B)
```

`XifMaster` is a deprecated alias that subclasses `XifHost` (kept for compatibility). Prefer `XifHost` in new code.

#### `XifHost` constructor parameters

* _bus_: `XifBus` with XIF interface signals
* _clock_: clock signal
* _timeout_max_: maximum clock cycles to wait for ready/result (optional, default `100`)

#### Methods

* `enable_logging()` / `disable_logging()`: control debug logging
* `calc_instr(...)`: build the instruction word (override in a subclass for a specific opcode)
* `calc_result(rs0, rs1, expected_val=-1)`: compute or pass through the expected result (override as needed)
* `commit(id, wait_cycle=1, kill=0)`: drive the commit channel
* `result(id, expected_val=-1)`: wait for and check the result channel
* `write_xx(rs0=0, rs1=0, expected_val=-1, mode=XifMode.MMODE)`: issue an instruction with source registers, commit, and check the result

Privilege mode values are in `XifMode` (`UMODE`, `SMODE`, `MMODE`).

Example subclass (pattern used in the debug tests):

```python
from cocotbext.xif import XifHost

class BitrevXifHost(XifHost):
    def calc_instr(self, rd=10, rs1=5, rs2=6, rm=0):
        instr = 0x2B
        instr |= (rd & 0x1F) << 7
        instr |= 0x7 << 12
        instr |= (rs1 & 0x1F) << 15
        instr |= 0x02 << 25
        return instr

    def calc_result(self, rs0, rs1, expected_val=-1):
        if expected_val != -1:
            return expected_val
        return int(f"{rs0:032b}"[::-1], 2)
```

### XIF Monitor

`XifMonitor` observes XIF transactions and can verify that signal changes are clock-synchronous.

```python
from cocotbext.xif import XifBus, XifMonitor

bus = XifBus.from_prefix(dut, "s_xif")
monitor = XifMonitor(bus, dut.clk_i)
monitor.enable_logging()
```

#### Methods

* `enable_logging()` / `disable_logging()`
* `enable_check_sync()`: check that signal changes align with the clock edge
* `disable_check_sync()`: disable the synchronous signal check

### XIF Device / RAM

`XifDevice` is the preferred device-side responder name. `XifSlave` remains as a deprecated alias subclassing `XifDevice`. `XifRam` extends `XifDevice` with an in-memory backing store.

These classes are still evolving; see the package sources and tests for current capabilities.

### Naming

| Preferred | Deprecated alias |
|-----------|------------------|
| `XifHost` | `XifMaster` |
| `XifDevice` | `XifSlave` |

## Running tests

From a suite directory under `tests/`:

```bash
source ~/.venv/horcrux-3.13.5/bin/activate   # or your cocotb venv
cd tests/test_xif_copro
make sim SIM=verilator WAVES=0
```

| Suite | Description | Verilator | Icarus |
|-------|-------------|-----------|--------|
| `tests/test_xif_copro` | Example XIF coprocessor (bitrev) | Pass | Pass |
| `tests/test_fpu_ss` | FPU subsystem over XIF | Pass | Pass |
| `tests/test_ara` | PULP Ara vector unit over XIF | Pass | Fail (compile; use Verilator) |

Icarus runs need a prebuilt Verilog netlist from `make sv2v` where applicable. Prefer `SIM=verilator` for Ara.
