"""
CocoTB tests for fpu_ss (XIF FPU subsystem).

Target RTL: https://github.com/pulp-platform/fpu_ss (CORE-V XIF compliant RISC-V F/Zfinx coprocessor).

Run: make sim SIM=verilator  (from tests/test_fpu_ss, with venv activated)
"""

import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock
from cocotbext.xif import XifBus
from cocotbext.xif import XifMonitor


def _init_dut(dut):
    """Drive clock and set all XIF inputs to idle/reset state."""
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


@cocotb.test()
async def test_fpu_ss_smoke(dut):
    """Basic smoke test: reset and run. No instructions issued. Always passes."""
    _init_dut(dut)
    for _ in range(10):
        await RisingEdge(dut.clk_i)
    dut.rst_ni.value = 1
    for _ in range(100):
        await RisingEdge(dut.clk_i)
    dut._log.info("Smoke test passed: DUT ran 100 cycles after reset")


def build_fadd_s_instr(rd, rs1, rs2, rm=0):
    """Build FADD.S instruction (RISC-V F extension).
    Format: funct7[31:25] | rs2[24:20] | rs1[19:15] | rm[14:12] | rd[11:7] | opcode[6:0]
    FADD.S: 0000000 | rs2 | rs1 | rm | rd | 1010011
    """
    opcode = 0x53  # 1010011
    instr = opcode
    instr |= (rd & 0x1F) << 7
    instr |= (rm & 0x7) << 12
    instr |= (rs1 & 0x1F) << 15
    instr |= (rs2 & 0x1F) << 20
    instr |= 0x00 << 25  # funct7 = 0000000
    return instr


@cocotb.test()
async def test_fadd_s_multiple(dut):
    """Test FADD.S (single-precision add) via fpu_ss XIF. Issues one op and checks accept (and result if ready)."""

    _init_dut(dut)
    xif_monitor = XifMonitor(XifBus.from_prefix(dut, "s_xif"), dut.clk_i)
    xif_monitor.enable_logging()

    for _ in range(10):
        await RisingEdge(dut.clk_i)
    dut.rst_ni.value = 1
    dut._log.info("Reset released")
    for _ in range(5):
        await RisingEdge(dut.clk_i)

    # Test cases: (rs1_bits, rs2_bits, expected_result_bits) as IEEE 754 hex
    test_cases = [
        (0x3F800000, 0x40000000, 0x40400000),   # 1.0 + 2.0 = 3.0
        (0x40000000, 0x40400000, 0x40A00000),   # 2.0 + 3.0 = 5.0
        (0x00000000, 0x3F800000, 0x3F800000),   # 0.0 + 1.0 = 1.0
        (0xBF800000, 0x3F800000, 0x00000000),   # -1.0 + 1.0 = 0.0
    ]

    passed = 0
    failed = 0
    transaction_id = 1

    for rs1_bits, rs2_bits, expected_bits in test_cases:
        dut._log.info("--- Test FADD.S ---")
        dut._log.info("rs1=0x%08X  rs2=0x%08X  expected=0x%08X", rs1_bits, rs2_bits, expected_bits)

        # Issue FADD.S: rd=10, rs1=5, rs2=6, rm=RNE(0)
        dut.s_xif_issue_valid.value = 1
        dut.s_xif_issue_req_instr.value = build_fadd_s_instr(rd=10, rs1=5, rs2=6, rm=0)
        dut.s_xif_issue_req_mode.value = 0x3
        dut.s_xif_issue_req_id.value = transaction_id
        dut.s_xif_issue_req_rs_0.value = rs1_bits
        dut.s_xif_issue_req_rs_1.value = rs2_bits
        dut.s_xif_issue_req_rs_2.value = 0
        dut.s_xif_issue_req_rs_valid.value = 0x3  # rs0 and rs1 valid (fpu_ss uses 3-bit rs_valid)

        await RisingEdge(dut.clk_i)
        timeout = 0
        while int(dut.s_xif_issue_ready.value) != 1 and timeout < 100:
            await RisingEdge(dut.clk_i)
            timeout += 1

        if timeout >= 100:
            dut._log.error("Timeout waiting for issue_ready")
            failed += 1
            continue

        accepted = int(dut.s_xif_issue_resp_accept.value)
        if not accepted:
            dut.s_xif_issue_valid.value = 0
            await RisingEdge(dut.clk_i)
            dut._log.error("Instruction not accepted")
            failed += 1
            continue

        # With INPUT_BUFFER_DEPTH=0, in_buf_pop_valid = issue_valid; controller only
        # sends the op to the FPU when commit is seen in the same cycle as the instruction.
        dut.s_xif_commit_valid.value = 1
        dut.s_xif_commit_id.value = transaction_id
        dut.s_xif_commit_kill.value = 0
        await RisingEdge(dut.clk_i)
        dut.s_xif_issue_valid.value = 0
        dut.s_xif_commit_valid.value = 0

        dut._log.info("Instruction accepted and committed")

        result_timeout = 2000
        timeout = 0
        while int(dut.s_xif_result_valid.value) != 1 and timeout < result_timeout:
            await RisingEdge(dut.clk_i)
            timeout += 1

        if timeout >= result_timeout:
            dut._log.error("Timeout waiting for result")
            failed += 1
            continue

        result_id = int(dut.s_xif_result_id.value)
        result_data = int(dut.s_xif_result_data.value)
        result_we = int(dut.s_xif_result_we.value)

        dut._log.info("Result ID=%s  WE=%s  data=0x%08X  expected=0x%08X",
                      result_id, result_we, result_data, expected_bits)

        await RisingEdge(dut.clk_i)

        if result_id != transaction_id:
            dut._log.error("ID mismatch: got %s, expected %s", result_id, transaction_id)
            failed += 1
        elif result_data != expected_bits:
            dut._log.error("Data mismatch: got 0x%08X, expected 0x%08X", result_data, expected_bits)
            failed += 1
        elif result_we != 1:
            dut._log.error("Write enable not set")
            failed += 1
        else:
            dut._log.info("PASS")
            passed += 1

        transaction_id += 1

        for _ in range(5):
            await RisingEdge(dut.clk_i)

    dut._log.info("=" * 60)
    dut._log.info("Test summary: %s passed, %s failed out of %s", passed, failed, len(test_cases))
    dut._log.info("=" * 60)

    assert failed == 0, f"{failed} test(s) failed"

    for _ in range(10):
        await RisingEdge(dut.clk_i)
