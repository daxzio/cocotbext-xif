# CocoTB test for fpu_ss (XIF FPU subsystem from tests/rtl/fpu_ss)
# Requires fpnew: use FPNEW_ROOT or default $(ASIC_DIR)/fpnew (clone pulp-platform/fpnew there)
SIM ?= verilator
TOPLEVEL_LANG = verilog
RTLFLO_PATH?=../rtlflo
ASIC_DIR ?= ../rtl

TOPLEVEL = fpu_ss_wrapper
MODULE = test_dut

VERILOG_INCLUDE_DIRS = \
	$(ASIC_DIR)/fpu_ss \
	$(ASIC_DIR)/fpnew \
	$(ASIC_DIR)/fpnew/common_cells/include

# Common FIFOs used by fpu_ss (xif_copro)
EXT_VERILOG_SOURCES += \
	$(ASIC_DIR)/xif_copro/common/fifo_v3.sv \
	$(ASIC_DIR)/xif_copro/common/stream_fifo.sv

# fpnew (required for fpu_ss)
EXT_VERILOG_SOURCES += \
	$(ASIC_DIR)/fpnew/fpnew_pkg.sv \
	$(ASIC_DIR)/fpnew/fpnew_rounding.sv \
	$(ASIC_DIR)/fpnew/fpnew_classifier.sv \
	$(ASIC_DIR)/fpnew/fpnew_opgroup_block.sv \
	$(ASIC_DIR)/fpnew/fpnew_opgroup_fmt_slice.sv \
	$(ASIC_DIR)/fpnew/fpnew_opgroup_multifmt_slice.sv \
	$(ASIC_DIR)/fpnew/fpnew_fma.sv \
	$(ASIC_DIR)/fpnew/fpnew_fma_multi.sv \
	$(ASIC_DIR)/fpnew/fpnew_noncomp.sv \
	$(ASIC_DIR)/fpnew/fpnew_cast_multi.sv \
	$(ASIC_DIR)/fpnew/fpnew_divsqrt_multi.sv \
	$(ASIC_DIR)/fpnew/fpnew_divsqrt_th_32.sv \
	$(ASIC_DIR)/fpnew/fpnew_top.sv

# fpu_div_sqrt_mvp (used by fpnew)
EXT_VERILOG_SOURCES += \
	$(ASIC_DIR)/fpnew/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv \
	$(ASIC_DIR)/fpnew/fpu_div_sqrt_mvp/hdl/control_mvp.sv \
	$(ASIC_DIR)/fpnew/fpu_div_sqrt_mvp/hdl/preprocess_mvp.sv \
	$(ASIC_DIR)/fpnew/fpu_div_sqrt_mvp/hdl/iteration_div_sqrt_mvp.sv \
	$(ASIC_DIR)/fpnew/fpu_div_sqrt_mvp/hdl/norm_div_sqrt_mvp.sv \
	$(ASIC_DIR)/fpnew/fpu_div_sqrt_mvp/hdl/nrbd_nrsc_mvp.sv \
	$(ASIC_DIR)/fpnew/fpu_div_sqrt_mvp/hdl/div_sqrt_top_mvp.sv \
# 	$(ASIC_DIR)/fpnew/fpu_div_sqrt_mvp/hdl/div_sqrt_mvp_wrapper.sv \

# common_cells (used by fpnew: lzc, rr_arb_tree, registers.svh)
EXT_VERILOG_SOURCES += \
	$(ASIC_DIR)/fpnew/common_cells/src/cf_math_pkg.sv \
	$(ASIC_DIR)/fpnew/common_cells/src/lzc.sv \
	$(ASIC_DIR)/fpnew/common_cells/src/rr_arb_tree.sv

# fpu_ss RTL from tests/rtl/fpu_ss
EXT_VERILOG_SOURCES += \
	$(ASIC_DIR)/fpu_ss/fpu_ss_pkg.sv \
	$(ASIC_DIR)/fpu_ss/fpu_ss_instr_pkg.sv \
	$(ASIC_DIR)/fpu_ss/fpu_ss_prd_f_pkg.sv \
	$(ASIC_DIR)/fpu_ss/fpu_ss_prd_zfinx_pkg.sv \
	$(ASIC_DIR)/fpu_ss/fpu_ss_compressed_predecoder.sv \
	$(ASIC_DIR)/fpu_ss/fpu_ss_predecoder.sv \
	$(ASIC_DIR)/fpu_ss/fpu_ss_decoder.sv \
	$(ASIC_DIR)/fpu_ss/fpu_ss_csr.sv \
	$(ASIC_DIR)/fpu_ss/fpu_ss_controller.sv \
	$(ASIC_DIR)/fpu_ss/fpu_ss_regfile.sv \
	$(ASIC_DIR)/fpu_ss/fpu_ss.sv

# Wrapper last so fpu_ss_pkg (and fpnew_pkg) are compiled before it
INT_VERILOG_SOURCES += \
	./fpu_ss_wrapper.sv

SV2V_EXT_SOURCES := $(EXT_VERILOG_SOURCES)
SV2V_INT_SOURCES := $(INT_VERILOG_SOURCES)

FPU_SS_SV2V_DEFINES := VERILATOR COMMON_CELLS_ASSERTS_OFF

.PHONY: sv2v
sv2v:
	sv2v $(addprefix -I, $(VERILOG_INCLUDE_DIRS)) \
		$(addprefix -D, $(FPU_SS_SV2V_DEFINES)) \
		$(SV2V_EXT_SOURCES) \
		$(SV2V_INT_SOURCES) \
		--top $(TOPLEVEL) \
		--write=$(TOPLEVEL).v

ifeq ($(SIM),icarus)
INT_VERILOG_SOURCES := ./fpu_ss_wrapper.v
EXT_VERILOG_SOURCES :=
endif

# Verilator waivers for fpnew/fpu_div_sqrt_mvp/common_cells RTL
IGNORE_ARGS += -Wno-UNOPTFLAT
IGNORE_ARGS += -Wno-ASCRANGE
IGNORE_ARGS += -Wno-WIDTHEXPAND
IGNORE_ARGS += -Wno-WIDTHTRUNC
IGNORE_ARGS += -Wno-UNSIGNED

XILINX_PRE_CUSTOM +=\
    set_msg_config -id {HDL 9-1206} -new_severity {ADVISORY}; \
    set_msg_config -id {HDL 9-3952} -new_severity {ADVISORY}; \

include $(RTLFLO_PATH)/cocotb_helper.mak
include $(RTLFLO_PATH)/icarus_sv2v.mak

ifeq ($(SIM),icarus)
sim_build_icarus/sim.vvp: fpu_ss_wrapper.v
endif



