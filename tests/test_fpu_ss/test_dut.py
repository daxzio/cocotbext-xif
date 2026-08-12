"""
CocoTB tests for fpu_ss (XIF FPU subsystem).

Target RTL: https://github.com/pulp-platform/fpu_ss (CORE-V XIF compliant RISC-V F/Zfinx coprocessor).

Run: make sim SIM=verilator  (from tests/test_fpu_ss, with venv activated)
"""

import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock

from cocotbext.xif import XifBus, XifHost, XifMonitor, FaddSEncoder, XifMode

from xif_helpers import init_reset_before_host


async def _setup(dut):
    clock = Clock(dut.clk_i, 10, unit="ns")
    cocotb.start_soon(clock.start())
    init_reset_before_host(dut)

    xif_bus = XifBus.from_prefix(dut, "s_xif")
    host = XifHost(xif_bus, dut.clk_i, reset=dut.rst_ni, timeout_max=2000)
    monitor = XifMonitor(xif_bus, dut.clk_i)
    monitor.enable_logging()

    for _ in range(10):
        await RisingEdge(dut.clk_i)
    dut.rst_ni.value = 1
    dut._log.info("Reset released")
    for _ in range(5):
        await RisingEdge(dut.clk_i)

    return host, FaddSEncoder()


@cocotb.test()
async def test_fpu_ss_smoke(dut):
    """Basic smoke test: reset and run. No instructions issued."""
    clock = Clock(dut.clk_i, 10, unit="ns")
    cocotb.start_soon(clock.start())
    dut.rst_ni.value = 0
    for _ in range(10):
        await RisingEdge(dut.clk_i)
    dut.rst_ni.value = 1
    for _ in range(100):
        await RisingEdge(dut.clk_i)
    dut._log.info("Smoke test passed: DUT ran 100 cycles after reset")


@cocotb.test()
async def test_fadd_s_multiple(dut):
    """Test FADD.S (single-precision add) via fpu_ss XIF."""
    host, enc = await _setup(dut)
    instr = enc.encode()

    test_cases = [
        (0x3F800000, 0x40000000, 0x40400000),
        (0x40000000, 0x40400000, 0x40A00000),
        (0x00000000, 0x3F800000, 0x3F800000),
        (0xBF800000, 0x3F800000, 0x00000000),
    ]

    for rs1_bits, rs2_bits, expected_bits in test_cases:
        dut._log.info(
            "FADD.S rs1=0x%08X rs2=0x%08X expected=0x%08X",
            rs1_bits,
            rs2_bits,
            expected_bits,
        )
        await host.execute(
            instr,
            rs=(rs1_bits, rs2_bits),
            rs_valid=0x3,
            mode=XifMode.MMODE,
            expected=expected_bits,
        )
        for _ in range(5):
            await RisingEdge(dut.clk_i)

    for _ in range(10):
        await RisingEdge(dut.clk_i)
