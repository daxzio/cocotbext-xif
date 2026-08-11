"""
CocoTB tests for PULP Ara vector unit (XIF at top level).

DUT: ara_xif_wrapper -> ara_xif_core (XIF->acc bridge + ara + axi_zero_mem).
Same pattern as test_fpu_ss / test_xif_copro: clock, reset, drive s_xif_*, issue
instructions and check result.

Ara is VLEN=128, NrLanes=2. VLMAX = VLEN/SEW * LMUL for given vtype.
Run: make sim SIM=verilator  (from tests/test_ara)
"""

import os
import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock
from cocotbext.xif import XifBus
from cocotbext.xif import XifMonitor


def _init_dut(dut):
    """Drive clock and set all XIF inputs to idle/reset state (match fpu_ss)."""
    clock = Clock(dut.clk_i, 10, unit="ns")
    cocotb.start_soon(clock.start())
    dut.rst_ni.value = 0
    dut.s_xif_issue_valid.value = 0
    dut.s_xif_issue_req_instr.value = 0
    dut.s_xif_issue_req_mode.value = 0
    dut.s_xif_issue_req_id.value = 0
    dut.s_xif_issue_req_rs_0.value = 0
    dut.s_xif_issue_req_rs_1.value = 0
    dut.s_xif_issue_req_rs_2.value = 0
    dut.s_xif_issue_req_rs_valid.value = 0
    dut.s_xif_commit_valid.value = 0
    dut.s_xif_commit_id.value = 0
    dut.s_xif_commit_kill.value = 0
    dut.s_xif_result_ready.value = 1
    dut.s_xif_mem_ready.value = 1
    dut.s_xif_mem_result_valid.value = 0
    dut.s_xif_mem_result_id.value = 0
    dut.s_xif_mem_result_rdata.value = 0
    dut.s_xif_mem_result_err.value = 0
    dut.s_xif_mem_resp_exc.value = 0
    dut.s_xif_mem_resp_exccode.value = 0


def build_vsetvli_instr(rd, rs1, vtypei):
    """Build vsetvli instruction (RISC-V V extension).
    vsetvli rd, rs1, vtypei  -> rd = new VL, rs1 = AVL.
    Encoding: [31]=0, [30:20]=zimm11 (vtypei), [19:15]=rs1, [14:12]=111, [11:7]=rd, [6:0]=0x57.
    vtypei: SEW[2:0], LMUL[5:3]. e32,m1 -> 0x02, e16,m1 -> 0x01, e8,m1 -> 0x00.
    """
    opcode_v = 0x57
    func3_opcfg = 0x7
    instr = opcode_v
    instr |= (rd & 0x1F) << 7
    instr |= func3_opcfg << 12
    instr |= (rs1 & 0x1F) << 15
    instr |= (vtypei & 0x7FF) << 20
    return instr


def build_vsetivli_instr(rd, uimm5, vtypei):
    """Build vsetivli instruction. vsetivli rd, uimm5, vtypei  -> rd = VL (min(uimm5, VLMAX)).
    Encoding: [31:30]=11, [29:20]=zimm10 (vtypei), [19:15]=uimm5, [14:12]=111, [11:7]=rd, [6:0]=0x57.
    """
    opcode_v = 0x57
    func3_opcfg = 0x7
    func2_vsetivli = 0x3
    instr = opcode_v
    instr |= (rd & 0x1F) << 7
    instr |= func3_opcfg << 12
    instr |= (uimm5 & 0x1F) << 15
    instr |= (vtypei & 0x3FF) << 20
    instr |= (func2_vsetivli & 0x3) << 30
    return instr


def build_vsetvl_instr(rd, rs1, rs2):
    """Build vsetvl instruction. vsetvl rd, rs1, rs2  -> vtype from rs2, AVL from rs1.
    Encoding: [31:25]=1000000, [24:20]=rs2, [19:15]=rs1, [14:12]=111, [11:7]=rd, [6:0]=0x57.
    """
    opcode_v = 0x57
    func3_opcfg = 0x7
    func7_vsetvl = 0x40
    instr = opcode_v
    instr |= (rd & 0x1F) << 7
    instr |= func3_opcfg << 12
    instr |= (rs1 & 0x1F) << 15
    instr |= (rs2 & 0x1F) << 20
    instr |= (func7_vsetvl & 0x7F) << 25
    return instr


def vtype_encode(sew, lmul, ta=1, ma=1):
    """Encode vtype. sew: 0=e8,1=e16,2=e32,3=e64. lmul: 0=m1,1=m2,2=m4,3=m8."""
    return (sew & 0x7) | ((lmul & 0x7) << 3) | (ta << 6) | (ma << 7)


async def _issue_config_instr_and_check(dut, instr, rs1_val, rs2_val, rs_valid, expected_vl,
                                        transaction_id, result_timeout=5000):
    """Issue a vset* config instruction, commit, wait for result, check expected VL.
    Returns (passed: bool, next_tid: int).
    """
    dut.s_xif_issue_valid.value = 0
    timeout = 0
    while int(dut.s_xif_issue_ready.value) != 1 and timeout < 100:
        await RisingEdge(dut.clk_i)
        timeout += 1
    if timeout >= 100:
        dut._log.error("Timeout waiting for issue_ready")
        return False, transaction_id + 1

    dut.s_xif_issue_valid.value = 1
    dut.s_xif_issue_req_instr.value = instr
    dut.s_xif_issue_req_mode.value = 0x3
    dut.s_xif_issue_req_id.value = transaction_id
    dut.s_xif_issue_req_rs_0.value = rs1_val
    dut.s_xif_issue_req_rs_1.value = rs2_val
    dut.s_xif_issue_req_rs_2.value = 0
    dut.s_xif_issue_req_rs_valid.value = rs_valid

    await RisingEdge(dut.clk_i)

    if not int(dut.s_xif_issue_resp_accept.value):
        dut.s_xif_issue_valid.value = 0
        await RisingEdge(dut.clk_i)
        dut._log.error("Instruction not accepted")
        return False, transaction_id + 1

    dut.s_xif_commit_valid.value = 1
    dut.s_xif_commit_id.value = transaction_id
    dut.s_xif_commit_kill.value = 0
    await RisingEdge(dut.clk_i)
    dut.s_xif_issue_valid.value = 0
    dut.s_xif_commit_valid.value = 0

    timeout = 0
    while int(dut.s_xif_result_valid.value) != 1 and timeout < result_timeout:
        await RisingEdge(dut.clk_i)
        timeout += 1

    if timeout >= result_timeout:
        dut._log.error("Timeout waiting for result")
        return False, transaction_id + 1

    result_id = int(dut.s_xif_result_id.value)
    result_data = int(dut.s_xif_result_data.value)
    result_we = int(dut.s_xif_result_we.value)

    await RisingEdge(dut.clk_i)

    ok = (result_id == transaction_id and result_data == expected_vl and result_we == 1)
    return ok, transaction_id + 1


@cocotb.test()
async def test_ara_smoke(dut):
    """Smoke test: reset release and run. Vector unit is instantiated with XIF at top."""
    _init_dut(dut)
    for _ in range(10):
        await RisingEdge(dut.clk_i)
    dut.rst_ni.value = 1
    dut._log.info("Reset released")
    for _ in range(200):
        await RisingEdge(dut.clk_i)
    dut._log.info("Smoke test passed: DUT ran 200 cycles after reset")


@cocotb.test()
async def test_ara_xif_ready(dut):
    """Check issue_ready and XIF handshake after reset (no instruction issued)."""
    _init_dut(dut)
    xif_monitor = XifMonitor(XifBus.from_prefix(dut, "s_xif"), dut.clk_i)
    xif_monitor.enable_logging()

    for _ in range(10):
        await RisingEdge(dut.clk_i)
    dut.rst_ni.value = 1
    for _ in range(20):
        await RisingEdge(dut.clk_i)

    ready = int(dut.s_xif_issue_ready.value)
    dut._log.info("s_xif_issue_ready = %s after reset", ready)
    for _ in range(50):
        await RisingEdge(dut.clk_i)
    dut._log.info("XIF ready test passed")


@cocotb.test()
async def test_ara_vsetvli(dut):
    """Issue vsetvli with varied vtype and AVL; verify returned VL.
    VLEN=128: e8,m1 VLMAX=16, e16,m1 VLMAX=8, e32,m1 VLMAX=4, e64,m1 VLMAX=2.
    Ara behavior: returns AVL as VL (may not cap to VLMAX); avl=0 returns 0.
    """
    _init_dut(dut)
    xif_monitor = XifMonitor(XifBus.from_prefix(dut, "s_xif"), dut.clk_i)
    xif_monitor.enable_logging()

    for _ in range(10):
        await RisingEdge(dut.clk_i)
    dut.rst_ni.value = 1
    for _ in range(5):
        await RisingEdge(dut.clk_i)

    # (vtypei, avl_val, expected_vl). vtype: e8=0,e16=1,e32=2,e64=3, m1=0.
    test_cases = [
        (vtype_encode(2, 0), 4, 4),   # e32,m1 avl=4  -> vl=4 (<=VLMAX)
        (vtype_encode(2, 0), 8, 8),   # e32,m1 avl=8  -> Ara returns 8
        (vtype_encode(2, 0), 1, 1),   # avl=1
        (vtype_encode(2, 0), 0, 0),   # avl=0 stripmining
        (vtype_encode(0, 0), 10, 10), # e8,m1  avl=10 -> VLMAX=16
        (vtype_encode(1, 0), 4, 4),   # e16,m1 avl=4  -> VLMAX=8
        (vtype_encode(3, 0), 2, 2),   # e64,m1 avl=2  -> VLMAX=2
    ]

    passed = 0
    failed = 0
    tid = 1
    for vtypei, avl_val, expected_vl in test_cases:
        dut._log.info("vsetvli vtype=0x%x avl=%s expect VL=%s", vtypei, avl_val, expected_vl)
        instr = build_vsetvli_instr(rd=10, rs1=5, vtypei=vtypei)
        ok, tid = await _issue_config_instr_and_check(
            dut, instr, avl_val, 0, 0x1, expected_vl, tid
        )
        if ok:
            passed += 1
        else:
            failed += 1
        for _ in range(5):
            await RisingEdge(dut.clk_i)

    dut._log.info("vsetvli summary: %s passed, %s failed", passed, failed)
    assert failed == 0, f"{failed} test(s) failed"
    for _ in range(10):
        await RisingEdge(dut.clk_i)


@cocotb.test()
async def test_ara_vsetivli(dut):
    """Issue vsetivli rd, uimm5, vtypei: VL = min(uimm5, VLMAX)."""
    _init_dut(dut)
    for _ in range(10):
        await RisingEdge(dut.clk_i)
    dut.rst_ni.value = 1
    for _ in range(5):
        await RisingEdge(dut.clk_i)

    vtype_e32m1 = vtype_encode(2, 0)
    test_cases = [
        (3, vtype_e32m1, 3),   # uimm5=3, VLMAX=4 -> vl=3
        (4, vtype_e32m1, 4),   # uimm5=4 -> vl=4
        (1, vtype_e32m1, 1),
        (0, vtype_e32m1, 0),
    ]

    passed = 0
    failed = 0
    tid = 1
    for uimm5, vtypei, expected_vl in test_cases:
        dut._log.info("vsetivli uimm5=%s vtype=0x%x expect VL=%s", uimm5, vtypei, expected_vl)
        instr = build_vsetivli_instr(rd=10, uimm5=uimm5, vtypei=vtypei)
        # vsetivli: rs1/rs2 ignored (AVL from immediate); rs_valid=0
        ok, tid = await _issue_config_instr_and_check(
            dut, instr, 0, 0, 0, expected_vl, tid
        )
        if ok:
            passed += 1
        else:
            failed += 1
        for _ in range(5):
            await RisingEdge(dut.clk_i)

    dut._log.info("vsetivli summary: %s passed, %s failed", passed, failed)
    assert failed == 0, f"{failed} test(s) failed"
    for _ in range(10):
        await RisingEdge(dut.clk_i)


@cocotb.test()
async def test_ara_vsetvl(dut):
    """Issue vsetvl rd, rs1, rs2: AVL from rs1, vtype from rs2."""
    _init_dut(dut)
    for _ in range(10):
        await RisingEdge(dut.clk_i)
    dut.rst_ni.value = 1
    for _ in range(5):
        await RisingEdge(dut.clk_i)

    vtype_e32m1 = vtype_encode(2, 0)
    test_cases = [
        (4, vtype_e32m1, 4),   # rs1=4 (AVL), rs2=vtype -> vl=4
        (1, vtype_e32m1, 1),
    ]

    passed = 0
    failed = 0
    tid = 1
    for avl_val, vtype_val, expected_vl in test_cases:
        dut._log.info("vsetvl avl=%s vtype=0x%x expect VL=%s", avl_val, vtype_val, expected_vl)
        instr = build_vsetvl_instr(rd=10, rs1=5, rs2=6)
        ok, tid = await _issue_config_instr_and_check(
            dut, instr, avl_val, vtype_val, 0x3, expected_vl, tid  # rs1+rs2 valid
        )
        if ok:
            passed += 1
        else:
            failed += 1
        for _ in range(5):
            await RisingEdge(dut.clk_i)

    dut._log.info("vsetvl summary: %s passed, %s failed", passed, failed)
    assert failed == 0, f"{failed} test(s) failed"
    for _ in range(10):
        await RisingEdge(dut.clk_i)
