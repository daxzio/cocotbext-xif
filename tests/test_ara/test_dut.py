"""
CocoTB tests for PULP Ara vector unit (XIF at top level).

DUT: ara_xif_wrapper -> ara_xif_core (XIF->acc bridge + ara + axi_zero_mem).
Run: make sim SIM=verilator  (from tests/test_ara)
"""

import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock

from cocotbext.xif import XifBus, XifHost, XifMonitor, RvvConfigEncoder, vtype_encode, XifMode


async def _setup(dut, timeout_max=5000):
    clock = Clock(dut.clk_i, 10, unit="ns")
    cocotb.start_soon(clock.start())
    dut.rst_ni.value = 0

    xif_bus = XifBus.from_prefix(dut, "s_xif")
    host = XifHost(xif_bus, dut.clk_i, reset=dut.rst_ni, timeout_max=timeout_max)
    monitor = XifMonitor(xif_bus, dut.clk_i)
    monitor.enable_logging()

    for _ in range(10):
        await RisingEdge(dut.clk_i)
    dut.rst_ni.value = 1
    for _ in range(5):
        await RisingEdge(dut.clk_i)

    return host, RvvConfigEncoder()


@cocotb.test()
async def test_ara_smoke(dut):
    """Smoke test: reset release and run."""
    clock = Clock(dut.clk_i, 10, unit="ns")
    cocotb.start_soon(clock.start())
    dut.rst_ni.value = 0
    for _ in range(10):
        await RisingEdge(dut.clk_i)
    dut.rst_ni.value = 1
    dut._log.info("Reset released")
    for _ in range(200):
        await RisingEdge(dut.clk_i)
    dut._log.info("Smoke test passed: DUT ran 200 cycles after reset")


@cocotb.test()
async def test_ara_xif_ready(dut):
    """Check issue_ready after reset (no instruction issued)."""
    await _setup(dut)
    for _ in range(20):
        await RisingEdge(dut.clk_i)
    ready = int(dut.s_xif_issue_ready.value)
    dut._log.info("s_xif_issue_ready = %s after reset", ready)
    for _ in range(50):
        await RisingEdge(dut.clk_i)


@cocotb.test()
async def test_ara_vsetvli(dut):
    """Issue vsetvli with varied vtype and AVL; verify returned VL."""
    host, enc = await _setup(dut)

    test_cases = [
        (vtype_encode(2, 0), 4, 4),
        (vtype_encode(2, 0), 8, 8),
        (vtype_encode(2, 0), 1, 1),
        (vtype_encode(2, 0), 0, 0),
        (vtype_encode(0, 0), 10, 10),
        (vtype_encode(1, 0), 4, 4),
        (vtype_encode(3, 0), 2, 2),
    ]

    failed = 0
    for vtypei, avl_val, expected_vl in test_cases:
        dut._log.info("vsetvli vtype=0x%x avl=%s expect VL=%s", vtypei, avl_val, expected_vl)
        instr = enc.encode(kind="vsetvli", rd=10, rs1=5, vtypei=vtypei)
        try:
            await host.execute(
                instr,
                rs=(avl_val, 0),
                rs_valid=0x1,
                mode=XifMode.MMODE,
                expected=expected_vl,
            )
        except Exception as exc:
            dut._log.error("vsetvli failed: %s", exc)
            failed += 1
        for _ in range(5):
            await RisingEdge(dut.clk_i)

    assert failed == 0, f"{failed} test(s) failed"


@cocotb.test()
async def test_ara_vsetivli(dut):
    """Issue vsetivli rd, uimm5, vtypei."""
    host, enc = await _setup(dut)
    vtype_e32m1 = vtype_encode(2, 0)
    test_cases = [(3, vtype_e32m1, 3), (4, vtype_e32m1, 4), (1, vtype_e32m1, 1), (0, vtype_e32m1, 0)]

    failed = 0
    for uimm5, vtypei, expected_vl in test_cases:
        instr = enc.encode(kind="vsetivli", rd=10, uimm5=uimm5, vtypei=vtypei)
        try:
            await host.execute(
                instr,
                rs=(0, 0),
                rs_valid=0,
                mode=XifMode.MMODE,
                expected=expected_vl,
            )
        except Exception as exc:
            dut._log.error("vsetivli failed: %s", exc)
            failed += 1
        for _ in range(5):
            await RisingEdge(dut.clk_i)

    assert failed == 0, f"{failed} test(s) failed"


@cocotb.test()
async def test_ara_vsetvl(dut):
    """Issue vsetvl rd, rs1, rs2."""
    host, enc = await _setup(dut)
    vtype_e32m1 = vtype_encode(2, 0)
    test_cases = [(4, vtype_e32m1, 4), (1, vtype_e32m1, 1)]

    failed = 0
    for avl_val, vtype_val, expected_vl in test_cases:
        instr = enc.encode(kind="vsetvl", rd=10, rs1=5, rs2=6)
        try:
            await host.execute(
                instr,
                rs=(avl_val, vtype_val),
                rs_valid=0x3,
                mode=XifMode.MMODE,
                expected=expected_vl,
            )
        except Exception as exc:
            dut._log.error("vsetvl failed: %s", exc)
            failed += 1
        for _ in range(5):
            await RisingEdge(dut.clk_i)

    assert failed == 0, f"{failed} test(s) failed"
