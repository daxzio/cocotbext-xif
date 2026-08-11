# CORE-V XIF interface modules for Cocotb

[![Build Status](https://github.com/daxzio/cocotbext-xif/actions/workflows/test_checkin.yml/badge.svg?branch=main)](https://github.com/daxzio/cocotbext-xif/actions/)
[![PyPI version](https://badge.fury.io/py/cocotbext-xif.svg)](https://pypi.org/project/cocotbext-xif)
[![Downloads](https://pepy.tech/badge/cocotbext-xif)](https://pepy.tech/project/cocotbext-xif)

GitHub repository: https://github.com/daxzio/cocotbext-xif

## Introduction

Simulation models for the [OpenHW Group CORE-V eXtension Interface (CV-X-IF / XIF)](https://docs.openhwgroup.org/projects/openhw-group-core-v-xif/) for use with [cocotb](https://github.com/cocotb/cocotb).

XIF lets a RISC-V CPU offload instructions to an external coprocessor over independent issue, memory, commit, and result channels. This package provides bus binding, a host-side driver, a monitor, a device-side model, and related helpers for building cocotb testbenches against XIF-attached DUTs.

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

See the `tests` directory for complete testbenches (`test_xif_copro`, `test_fpu_ss`, `test_ara`, `test_horcrux`).

### XIF Bus

`XifBus` maps an XIF interface on the DUT. Class methods `from_entity` and `from_prefix` match signals by name (with an optional prefix such as `s_xif`).

```python
from cocotbext.xif import XifBus

bus = XifBus.from_prefix(dut, "s_xif")
```

Bus width properties (`xlen`, `id_width`, `mem_data_width`, `rs_count`) are derived from the mapped signals.

#### Required signals (relative to prefix)

**Issue:** `issue_valid`, `issue_ready`, `issue_req_instr`, `issue_req_mode`, `issue_req_id`, `issue_req_rs_0`, `issue_req_rs_1`, `issue_req_rs_valid`, `issue_resp_accept`, `issue_resp_writeback`, `issue_resp_dualwrite`, `issue_resp_dualread`, `issue_resp_loadstore`, `issue_resp_exc`

**Memory:** `mem_valid`, `mem_ready`, `mem_req_id`, `mem_req_addr`, `mem_req_mode`, `mem_req_we`, `mem_req_size`, `mem_req_be`, `mem_req_wdata`, `mem_req_last`, `mem_resp_exc`, `mem_resp_exccode`, `mem_result_valid`, `mem_result_id`, `mem_result_rdata`, `mem_result_err`

**Commit:** `commit_valid`, `commit_id`, `commit_kill`

**Result:** `result_valid`, `result_ready`, `result_id`, `result_data`, `result_rd`, `result_we`, `result_exc`, `result_exccode`

#### Optional

`issue_req_rs_2`, `issue_req_ecs`, `issue_req_ecs_valid`, `mem_resp_dbg`, `mem_result_dbg`, `compressed_valid`, `compressed_req`

### XIF Host

`XifHost` is the CPU/host-side driver. It issues instructions on the XIF, handles commit, checks results, and optionally services the memory channel.

```python
from cocotbext.xif import XifBus, XifHost, BitrevEncoder, XifMode

bus = XifBus.from_prefix(dut, "s_xif")
host = XifHost(bus, dut.clk_i, reset=dut.rst_ni, timeout_max=2000)

enc = BitrevEncoder()
instr = enc.encode()

await host.execute(
    instr,
    rs=(0xDEADBEEF, 0),
    rs_valid=0x1,
    mode=XifMode.MMODE,
    expected=0xF77DB57B,
)
```

#### `XifHost` constructor parameters

* _bus_: `XifBus` with XIF interface signals
* _clock_: clock signal
* _reset_: optional reset signal (monitored for release)
* _reset_active_level_: reset polarity (default `False` = active low)
* _timeout_max_: maximum clock cycles to wait for ready/result (default `100`)
* _mem_: optional `Memory` backing store for the memory channel
* _commit_delay_: cycles to wait before driving commit (default `1`)

#### Methods

* `enable_logging()` / `disable_logging()`: control debug logging
* `execute(instr, rs=..., rs_valid=..., mode=..., expected=..., check_we=True, commit=True, kill=0, wait_ready_after=False)`: issue one instruction, commit, and wait for the result
* `issue_nowait(insn)`: queue an `XifInsn` for pipelined issue
* `wait(insn, wait_ready_after=False)`: wait for the result of a previously issued instruction
* `commit(id, wait_cycle=1, kill=0)`: drive the commit channel
* `wait_idle()`: wait until no instructions are outstanding

Privilege mode values are in `XifMode` (`UMODE`, `SMODE`, `MMODE`).

### Instruction encoders

DUT-specific instruction encoding lives in encoder classes (staged in `cocotbext.xif.encoders`, intended to move into each testbench over time):

```python
from cocotbext.xif import BitrevEncoder, FaddSEncoder, RvvConfigEncoder, HorcruxEncoder

enc = BitrevEncoder()
instr = enc.encode(rd=10, rs1=5)
expected = enc.model((0xDEADBEEF,))
```

Generic RISC-V field packing (`encode_r`, `encode_r4`, `encode_i`) is in `cocotbext.xif.riscv`.

### XIF Monitor

`XifMonitor` observes all four XIF channels and records transactions.

```python
from cocotbext.xif import XifBus, XifMonitor

bus = XifBus.from_prefix(dut, "s_xif")
monitor = XifMonitor(bus, dut.clk_i, check_protocol=True)
monitor.enable_logging()
```

#### Methods

* `enable_logging()` / `disable_logging()`
* `enable_check_sync()`: check that signal changes align with the clock edge
* `disable_check_sync()`: disable the synchronous signal check

### XIF Device

`XifDevice` is the coprocessor-side model for testing CPU-side DUTs. It accepts issue requests, observes commit, and can drive results and memory requests.

```python
from cocotbext.xif import XifDevice

def handler(insn):
    return insn.rs[0] + insn.rs[1]

device = XifDevice(bus, dut.clk_i, handler=handler)
```

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
| `tests/test_horcrux` | HORCRUX crypto coprocessor over XIF | Pass | — |

Icarus runs need a prebuilt Verilog netlist from `make sv2v` where applicable. Prefer `SIM=verilator` for Ara.
