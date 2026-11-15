# CocoTB test for HORCRUX coprocessor (coproc_wrapper over CV-X-IF).
# RTL: vendored under tests/rtl/horcrux (see scripts/vendor_test_rtl.sh).

SIM ?= verilator
# WAVES?= 0
export SIM
# export WAVES
TOPLEVEL_LANG = verilog
RTLFLO_PATH ?= ../rtlflo

HORCRUX_DIR ?= $(abspath ../rtl/horcrux)
HORCRUX_RTL := $(HORCRUX_DIR)/hw/ip/coprocessors
HORCRUX_VENDOR := $(HORCRUX_DIR)/hw/vendor/x-heep/hw/vendor

TOPLEVEL = horcrux_xif_wrapper
MODULE = test_dut

VERILOG_INCLUDE_DIRS += \
	$(HORCRUX_RTL)/include \
	$(HORCRUX_VENDOR)/openhwgroup_cv32e40x/rtl/include \
	$(HORCRUX_VENDOR)/openhwgroup_cv32e40x/rtl \
	$(HORCRUX_VENDOR)/esl_epfl_cv32e40px/rtl/include

EXT_VERILOG_SOURCES += \
	$(HORCRUX_VENDOR)/openhwgroup_cv32e40x/rtl/include/cv32e40x_pkg.sv \
	$(HORCRUX_VENDOR)/openhwgroup_cv32e40x/rtl/if_xif.sv \
	$(HORCRUX_RTL)/include/cv32e40px_pkg.sv \
	$(HORCRUX_RTL)/include/cv32e40px_core_v_xif_pkg.sv \
	$(HORCRUX_RTL)/include/horcrux_pkg.sv \
	$(HORCRUX_RTL)/sampler.sv \
	$(HORCRUX_RTL)/keccak/pkg_keccak.sv \
	$(HORCRUX_RTL)/keccak/keccak_cu.sv \
	$(HORCRUX_RTL)/keccak/keccak_dp.sv \
	$(HORCRUX_RTL)/keccak/keccak_round_constants_gen.sv \
	$(HORCRUX_RTL)/keccak/keccak_round.sv \
	$(HORCRUX_RTL)/keccak/keccak_f.sv \
	$(HORCRUX_RTL)/horcrux_register.sv \
	$(HORCRUX_RTL)/unified_mul_32x32.sv \
	$(HORCRUX_RTL)/shared_multiplication_logic.sv \
	$(HORCRUX_RTL)/fpr.sv \
	$(HORCRUX_RTL)/multiplier_tree.sv \
	$(HORCRUX_RTL)/barrett.sv \
	$(HORCRUX_RTL)/chain_lengths.sv \
	$(HORCRUX_RTL)/sphincs_ops.sv \
	$(HORCRUX_RTL)/commit_stage.sv \
	$(HORCRUX_RTL)/id_stage.sv \
	$(HORCRUX_RTL)/horcrux.sv \
	$(HORCRUX_RTL)/horcrux_top.sv \
	$(HORCRUX_RTL)/coproc_wrapper.sv

INT_VERILOG_SOURCES += \
	./horcrux_xif_wrapper.sv

SV2V_EXT_SOURCES := $(EXT_VERILOG_SOURCES)
SV2V_INT_SOURCES := $(INT_VERILOG_SOURCES)

IGNORE_ARGS += -Wno-UNOPTFLAT
IGNORE_ARGS += -Wno-WIDTHEXPAND
IGNORE_ARGS += -Wno-WIDTHTRUNC
IGNORE_ARGS += -Wno-UNSIGNED
IGNORE_ARGS += -Wno-CASEINCOMPLETE
IGNORE_ARGS += -Wno-ASCRANGE
IGNORE_ARGS += -Wno-SELRANGE
IGNORE_ARGS += -Wno-COMBDLY
COMPILE_ARGS += -Wno-fatal

BUILD_ARGS += -j$(shell nproc 2>/dev/null || echo 8)

ifeq ($(SIM),icarus)
INT_VERILOG_SOURCES := ./horcrux_xif_wrapper.v
EXT_VERILOG_SOURCES :=
endif

ifneq (,$(wildcard ./makefile_synth.mak))
    include ./makefile_synth.mak
endif

include $(RTLFLO_PATH)/cocotb_helper.mak

# Vivado must see the SV RTL, not the Icarus sv2v netlist or a duplicated file list.
FPGA_DESIGN := $(SV2V_EXT_SOURCES) $(SV2V_INT_SOURCES)
XILINX_DEFINES :=
XILINX_GENERICS :=

ifeq ($(SIM),icarus)
sim_build_icarus/sim.vvp: horcrux_xif_wrapper.v
endif

.PHONY: sv2v
sv2v:
	sv2v \
		$(addprefix -I, $(VERILOG_INCLUDE_DIRS)) \
		--top $(TOPLEVEL) $(SV2V_EXT_SOURCES) $(SV2V_INT_SOURCES) \
		--write=horcrux_xif_wrapper.v
