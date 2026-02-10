"""
CocoTB test for XIF Coprocessor
Tests the bit reversal instruction through the XIF interface
"""

import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock
from cocotbext.xif import XifBus
from cocotbext.xif import XifMonitor
from cocotbext.xif import XifMaster

#xif_bus = XifBus(dut)


def build_bitrev_instr(rd, rs1):
    """Build a BITREV instruction
    Format: funct7[31:25] | rs2[24:20] | rs1[19:15] | funct3[14:12] | rd[11:7] | opcode[6:0]
    BITREV: 0000010 | 00000 | rs1 | 111 | rd | 0101011
    """
    instr = 0
    instr |= 0x2B                # opcode [6:0] = 0101011
    instr |= (rd & 0x1F) << 7    # rd [11:7]
    instr |= 0x7 << 12           # funct3 [14:12] = 111
    instr |= (rs1 & 0x1F) << 15  # rs1 [19:15]
    instr |= 0x0 << 20           # rs2 [24:20] = 00000 (unused)
    instr |= 0x02 << 25          # funct7 [31:25] = 0000010
    return instr

@cocotb.test()
async def test_bitrev_multiplex(dut):
    """Test multiple bit reversals"""
    
    # Start clock (10ns period = 100MHz)
    clock = Clock(dut.clk_i, 10, unit="ns")
    cocotb.start_soon(clock.start())
    # Initialize all signals
    dut.rst_ni.value = 0

    xif_bus = XifBus.from_prefix(dut, "s_xif")
    xif_monitor = XifMonitor(xif_bus, dut.clk_i)
    xif_driver = XifMaster(xif_bus, dut.clk_i)
    xif_monitor.enable_logging()
    # await xif_monitor.run()
    
    # Hold reset for 10 cycles
    for _ in range(10):
        await RisingEdge(dut.clk_i)
    
    dut.rst_ni.value = 1
    dut._log.info("Reset released")
    
    # Wait a few cycles after reset
    for _ in range(5):
        await RisingEdge(dut.clk_i)
    
    await xif_driver.write_xx(0xDEADBEEF, 0xF77DB57B)
    await xif_driver.write_xx(0x12345678, 0x1E6A2C48)
    
#     # Test cases: input value and expected reversed value
#     test_cases = [
#         # (0x00000000, 0x00000000, "all zeros"),
#         # (0xFFFFFFFF, 0xFFFFFFFF, "all ones"),
#         # (0x00000001, 0x80000000, "single bit low"),
#         # (0x80000000, 0x00000001, "single bit high"),
#         # (0xB0000000, 0x0000000D, "README example"),
#         (0xDEADBEEF, 0xF77DB57B, "DEADBEEF"),
#         (0x12345678, 0x1E6A2C48, "pattern"),
#     ]
#     
#     passed = 0
#     failed = 0
#     transaction_id = 1
    
#     for input_val, expected_val, test_name in test_cases:
#         dut._log.info(f"--- Test: {test_name} ---")
#         dut._log.info(f"Input: 0x{input_val:08X}")
#         
#         # Send instruction via issue interface
#         dut.s_xif_issue_valid.value = 1
#         dut.s_xif_issue_req_instr.value = build_bitrev_instr(rd=10, rs1=5)
#         dut.s_xif_issue_req_mode.value = 0x3  # Machine mode
#         dut.s_xif_issue_req_id.value = transaction_id
#         dut.s_xif_issue_req_rs_0.value = input_val
#         dut.s_xif_issue_req_rs_1.value = 0
#         dut.s_xif_issue_req_rs_valid.value = 0x1  # Only rs1 valid
#         
#         # Wait for ready
#         await RisingEdge(dut.clk_i)
#         timeout = 0
#         while int(dut.s_xif_issue_ready.value) != 1 and timeout < 100:
#             await RisingEdge(dut.clk_i)
#             timeout += 1
#         
#         if timeout >= 100:
#             dut._log.error("Timeout waiting for issue_ready")
#             failed += 1
#             continue
#         
#         # Capture if accepted
#         accepted = int(dut.s_xif_issue_resp_accept.value)
#         await RisingEdge(dut.clk_i)
#         
#         dut.s_xif_issue_valid.value = 0
#         
#         if not accepted:
#             dut._log.error("Instruction not accepted!")
#             failed += 1
#             continue
#         
#         dut._log.info("Instruction accepted")
#         
#         # Wait a cycle before committing
#         await RisingEdge(dut.clk_i)
#         
#         # Commit the instruction
#         dut.s_xif_commit_valid.value = 1
#         dut.s_xif_commit_id.value = transaction_id
#         dut.s_xif_commit_kill.value = 0
#         await RisingEdge(dut.clk_i)
#         dut.s_xif_commit_valid.value = 0
#         
#         dut._log.info("Instruction committed")
#         
#         # Wait for result
#         timeout = 0
#         while int(dut.s_xif_result_valid.value) != 1 and timeout < 1000:
#             await RisingEdge(dut.clk_i)
#             timeout += 1
#         
#         if timeout >= 1000:
#             dut._log.error("Timeout waiting for result")
#             failed += 1
#             continue
#         
#         # Check result
#         result_id = int(dut.s_xif_result_id.value)
#         result_data = int(dut.s_xif_result_data.value)
#         result_we = int(dut.s_xif_result_we.value)
#         
#         dut._log.info(f"Result ID: {result_id}, WE: {result_we}")
#         dut._log.info(f"Result: 0x{result_data:08X}")
#         dut._log.info(f"Expected: 0x{expected_val:08X}")
#         
#         # Acknowledge result
#         await RisingEdge(dut.clk_i)
#         
#         # Verify
#         if result_id != transaction_id:
#             dut._log.error(f"ID mismatch: got {result_id}, expected {transaction_id}")
#             failed += 1
#         elif result_data != expected_val:
#             dut._log.error(f"Data mismatch: got 0x{result_data:08X}, expected 0x{expected_val:08X}")
#             failed += 1
#         elif result_we != 1:
#             dut._log.error(f"Write enable not set")
#             failed += 1
#         else:
#             dut._log.info("PASS")
#             passed += 1
#         
#         transaction_id += 1
#         
#         # Wait between tests
#         for _ in range(5):
#             await RisingEdge(dut.clk_i)
#     
#     # Final summary
#     dut._log.info("=" * 60)
#     dut._log.info(f"Test Summary: {passed} passed, {failed} failed out of {len(test_cases)}")
#     dut._log.info("=" * 60)
#     
#     assert failed == 0, f"{failed} test(s) failed"
    
    # Wait a bit before ending
    for _ in range(10):
        await RisingEdge(dut.clk_i)
