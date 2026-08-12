"""
CocoTB test for XIF Coprocessor
Tests the bit reversal instruction through the XIF interface
"""

import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock

from cocotbext.xif import XifBus, XifHost, XifMonitor, BitrevEncoder, XifMode

from xif_helpers import init_reset_before_host


async def _setup(dut):
    clock = Clock(dut.clk_i, 10, unit="ns")
    cocotb.start_soon(clock.start())

    init_reset_before_host(dut)
    xif_bus = XifBus.from_prefix(dut, "s_xif")
    host = XifHost(xif_bus, dut.clk_i, reset=dut.rst_ni, reset_active_level=False)
    XifMonitor(xif_bus, dut.clk_i)

    for _ in range(10):
        await RisingEdge(dut.clk_i)
    dut.rst_ni.value = 1
    dut._log.info("Reset released")
    for _ in range(5):
        await RisingEdge(dut.clk_i)

    return host, BitrevEncoder()


@cocotb.test()
async def test_bitrev_multiple(dut):
    """Test multiple bit reversals via XifHost.execute()."""
    host, enc = await _setup(dut)

    test_cases = [
        (0xDEADBEEF, 0xF77DB57B, "DEADBEEF"),
        (0x12345678, 0x1E6A2C48, "pattern"),
        (0x64563415, enc.model((0x64563415,)), "computed"),
    ]

    instr = enc.encode()
    for input_val, expected_val, test_name in test_cases:
        dut._log.info("--- Test: %s ---", test_name)
        dut._log.info("Input: 0x%08X", input_val)
        await host.execute(
            instr,
            rs=(input_val, 0),
            rs_valid=0x1,
            mode=XifMode.MMODE,
            expected=expected_val,
        )
        for _ in range(5):
            await RisingEdge(dut.clk_i)

    for _ in range(10):
        await RisingEdge(dut.clk_i)
