SIM?=verilator
TOPLEVEL_LANG=verilog
WORK_BASE?=..
ASIC_DIR?=../rtl

VERILOG_INCLUDE_DIRS = \
   ${ASIC_DIR}/xif_copro/xif_copro \
   ${ASIC_DIR}/rtl

TOPLEVEL = xif_copro_wrapper
MODULE?=test_dut

SV2V_EXT_SOURCES = \
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

SV2V_INT_SOURCES = \
    ./xif_copro_wrapper.sv

EXT_VERILOG_SOURCES += $(SV2V_EXT_SOURCES)
INT_VERILOG_SOURCES += $(SV2V_INT_SOURCES)

ifeq ($(SIM), icarus)
INT_VERILOG_SOURCES := ./xif_copro_wrapper.v
EXT_VERILOG_SOURCES :=
endif

IGNORE_ARGS += -Wno-UNOPTFLAT

include ${WORK_BASE}/rtlflo/cocotb_helper.mak

ifeq ($(SIM),icarus)
sim_build_icarus/sim.vvp: xif_copro_wrapper.v
endif

.PHONY: sv2v
sv2v:
	sv2v $(addprefix -I, $(VERILOG_INCLUDE_DIRS)) \
		--top $(TOPLEVEL) $(SV2V_EXT_SOURCES) $(SV2V_INT_SOURCES) \
		--write=$(TOPLEVEL).v
