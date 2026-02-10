SIM?=xcelium
TOPLEVEL_LANG=verilog
WORK_BASE?=..
# ASIC_DIR?=${VCADprojectUserWorkDir}/hulk_design
ASIC_DIR?=../rtl

VERILOG_INCLUDE_DIRS = \
   ${ASIC_DIR}/xif_copro/xif_copro \
   ${ASIC_DIR}/rtl
   
TOPLEVEL = xif_copro_wrapper
MODULE?=test_dut

ifeq ($(SIM), icarus)
INT_VERILOG_SOURCES += \
    ./xif_copro_wrapper.v \
    
else
EXT_VERILOG_SOURCES += \
    ${ASIC_DIR}/xif_copro/common/fifo_v3.sv \
    ${ASIC_DIR}/xif_copro/common/stream_fifo.sv \
    ${ASIC_DIR}/xif_copro/if_xif.sv \
    ${ASIC_DIR}/xif_copro/xif_copro/xif_copro_pkg.sv \
    ${ASIC_DIR}/xif_copro/xif_copro/xif_copro_predecoder_pkg.sv \
    ${ASIC_DIR}/xif_copro/xif_copro/xif_copro_instr_pkg.sv \
    ${ASIC_DIR}/xif_copro/xif_copro/xif_copro_controller.sv \
    ${ASIC_DIR}/xif_copro/xif_copro/xif_copro_decoder.sv \
    ${ASIC_DIR}/xif_copro/xif_copro/xif_copro_ex_stage.sv \
    ${ASIC_DIR}/xif_copro/xif_copro/xif_copro_predecoder.sv \
    ${ASIC_DIR}/xif_copro/xif_copro/xif_copro_regfile.sv \
    ${ASIC_DIR}/xif_copro/xif_copro/xif_copro.sv

INT_VERILOG_SOURCES += \
    ./xif_copro_wrapper.sv \

endif
# GENERICS += \

# DEFINES += \
# 	FPGA=1

IGNORE_ARGS += -Wno-UNOPTFLAT
# # Verilator specific flags
# EXTRA_ARGS += --timing -Wno-fatal
# COMPILE_ARGS += --timing -Wno-fatal
    
include ${WORK_BASE}/rtlflo/cocotb_helper.mak

sv2v:
# 	sv2v --top xif_copro ${EXT_VERILOG_SOURCES} > ${ASIC_DIR}/xif_copro/xif_copro/xif_copro.v
	sv2v ${EXT_VERILOG_SOURCES} ${INT_VERILOG_SOURCES} > ./xif_copro_wrapper.v

