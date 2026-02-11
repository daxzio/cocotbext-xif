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


class BitrevXifMaster(XifMaster):

#     def calc_instr(self, rd, rs1):
    def calc_instr(self, rd=10, rs1=5, rs2=6, rm=0):
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
    xif_driver = BitrevXifMaster(xif_bus, dut.clk_i)
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
    
    await xif_driver.write_xx(0xDEADBEEF, expected_val=0xF77DB57B)
    await xif_driver.write_xx(0x12345678, expected_val=0x1E6A2C48)
    
    # Wait a bit before ending
    for _ in range(10):
        await RisingEdge(dut.clk_i)
