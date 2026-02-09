# CocoTB test for PULP Ara vector unit only. XIF at top (ara_xif_wrapper -> ara_xif_core -> ara + axi_zero_mem).
# Explicit file list: only what the coprocessor needs. No generated .mak.
SIM ?= verilator
export SIM
TOPLEVEL_LANG = verilog
# WORK_BASE ?= ..
RTLFLO_PATH?=../rtlflo
ARA_ROOT ?= ../rtl/ara
# Fallback to ara.bck if CVA6 deps are missing (e.g. ara is a symlink to an Ara repo without deps)
ARA_CVA6_CONFIG := $(CURDIR)/$(ARA_ROOT)/hardware/deps/cva6/core/include/config_pkg.sv
# ifeq ($(wildcard $(ARA_CVA6_CONFIG)),)
#   ARA_ROOT := ../rtl/ara.bck
# endif
ASIC_DIR := ../rtl

TOPLEVEL = ara_xif_wrapper
MODULE = test_dut

# ---------- Include dirs (coprocessor only) ----------
VERILOG_INCLUDE_DIRS += \
	$(ASIC_DIR)/common_cells/include \
	$(ASIC_DIR)/axi/include \
	$(ASIC_DIR)/cva6/core/include \
	$(ASIC_DIR)/ara/hardware/include

# ---------- Defines ----------
DEFINES += \
	NR_LANES=2 \
	VLEN=128 \
	ARIANE_ACCELERATOR_PORT=1 \
	COMMON_CELLS_ASSERTS_OFF

# ---------- CVA6 config + serdiv (coprocessor only: acc types, serdiv for lane) ----------
# Omitted: wt_cache_pkg, std_cache_pkg (CVA6 cache); fpga-support-stubs, tc_sram_wrapper*,
# sram_pulp, sram_cache (CVA6 SoC/cache). Ara VRF uses tc_sram from tech_cells_generic.
EXT_VERILOG_SOURCES += \
	$(ASIC_DIR)/cva6/core/include/config_pkg.sv \
	$(ASIC_DIR)/cva6/core/include/cv64a6_imafdcv_sv39_config_pkg.sv \
	$(ASIC_DIR)/cva6/core/include/riscv_pkg.sv \
	$(ASIC_DIR)/cva6/core/include/ariane_pkg.sv \
	$(ASIC_DIR)/cva6/core/include/build_config_pkg.sv \
	$(ASIC_DIR)/cva6/core/serdiv.sv

# ---------- AXI (pkg + intf for types; axi_cut, axi_to_detailed_mem, axi_zero_mem) ----------
EXT_VERILOG_SOURCES += \
	$(ASIC_DIR)/axi/src/axi_pkg.sv \
	$(ASIC_DIR)/axi/src/axi_intf.sv \
	$(ASIC_DIR)/axi/src/axi_cut.sv \
	$(ASIC_DIR)/axi/src/axi_to_detailed_mem.sv \
	$(ASIC_DIR)/axi/src/axi_zero_mem.sv

# ---------- Common cells (from hierarchy + packages/deps needed by above) ----------
COMMON_CELLS := $(ASIC_DIR)/common_cells
EXT_VERILOG_SOURCES += \
	$(COMMON_CELLS)/src/cf_math_pkg.sv \
	$(COMMON_CELLS)/src/spill_register.sv \
	$(COMMON_CELLS)/src/spill_register_flushable.sv \
	$(COMMON_CELLS)/src/stream_fifo.sv \
	$(COMMON_CELLS)/src/stream_fork.sv \
	$(COMMON_CELLS)/src/stream_fork_dynamic.sv \
	$(COMMON_CELLS)/src/stream_join.sv \
	$(COMMON_CELLS)/src/stream_join_dynamic.sv \
	$(COMMON_CELLS)/src/stream_to_mem.sv \
	$(COMMON_CELLS)/src/stream_mux.sv \
	$(COMMON_CELLS)/src/stream_demux.sv \
	$(COMMON_CELLS)/src/stream_xbar.sv \
	$(COMMON_CELLS)/src/stream_intf.sv \
	$(COMMON_CELLS)/src/mem_to_banks_detailed.sv \
	$(COMMON_CELLS)/src/lzc.sv \
	$(COMMON_CELLS)/src/popcount.sv \
	$(COMMON_CELLS)/src/fifo_v3.sv \
	$(COMMON_CELLS)/src/delta_counter.sv \
	$(COMMON_CELLS)/src/counter.sv \
	$(COMMON_CELLS)/src/fall_through_register.sv

# ---------- FPnew (ara_pkg + lane vmfpu), tech_cells (VRF), common_cells extras ----------
FPNEW := $(ASIC_DIR)/ara.bck/hardware/deps/fpnew
FPDS := $(ASIC_DIR)/fpu_div_sqrt_mvp
TC := $(ASIC_DIR)/tech_cells_generic
EXT_VERILOG_SOURCES += \
	$(FPNEW)/src/fpnew_pkg.sv \
	$(FPNEW)/src/fpnew_rounding.sv \
	$(FPNEW)/src/fpnew_classifier.sv \
	$(FPNEW)/src/fpnew_opgroup_block.sv \
	$(FPNEW)/src/fpnew_opgroup_fmt_slice.sv \
	$(FPNEW)/src/fpnew_opgroup_multifmt_slice.sv \
	$(FPNEW)/src/fpnew_fma.sv \
	$(FPNEW)/src/fpnew_fma_multi.sv \
	$(FPNEW)/src/fpnew_noncomp.sv \
	$(FPNEW)/src/fpnew_cast_multi.sv \
	$(FPNEW)/src/fpnew_divsqrt_multi.sv \
	$(FPNEW)/src/fpnew_divsqrt_th_32.sv \
	$(FPNEW)/src/fpnew_divsqrt_th_64_multi.sv \
	$(FPNEW)/src/lfsr_sr.sv \
	$(FPNEW)/src/fpnew_sdotp_multi.sv \
	$(FPNEW)/src/fpnew_sdotp_multi_wrapper.sv \
	$(FPNEW)/src/fpnew_top.sv \
	$(FPDS)/hdl/defs_div_sqrt_mvp.sv \
	$(FPDS)/hdl/control_mvp.sv \
	$(FPDS)/hdl/preprocess_mvp.sv \
	$(FPDS)/hdl/iteration_div_sqrt_mvp.sv \
	$(FPDS)/hdl/norm_div_sqrt_mvp.sv \
	$(FPDS)/hdl/nrbd_nrsc_mvp.sv \
	$(FPDS)/hdl/div_sqrt_mvp_wrapper.sv \
	$(FPDS)/hdl/div_sqrt_top_mvp.sv \
	$(TC)/src/rtl/tc_sram.sv \
	$(TC)/src/rtl/tc_sram_impl.sv \
	$(TC)/src/rtl/tc_clk.sv \
	$(COMMON_CELLS)/src/stream_register.sv \
	$(COMMON_CELLS)/src/rr_arb_tree.sv \
	$(COMMON_CELLS)/src/mem_to_banks.sv

# ---------- Ara coprocessor RTL (from hierarchy, deduplicated) ----------
EXT_VERILOG_SOURCES += \
	$(ASIC_DIR)/ara/hardware/include/rvv_pkg.sv \
	$(ASIC_DIR)/ara/hardware/include/ara_pkg.sv \
	$(ASIC_DIR)/ara/hardware/src/segment_sequencer.sv \
	$(ASIC_DIR)/ara/hardware/src/ctrl_registers.sv \
	$(ASIC_DIR)/ara/hardware/src/cva6_accel_first_pass_decoder.sv \
	$(ASIC_DIR)/ara/hardware/src/ara_dispatcher.sv \
	$(ASIC_DIR)/ara/hardware/src/ara_sequencer.sv \
	$(ASIC_DIR)/ara/hardware/src/ara.sv \
	$(ASIC_DIR)/ara/hardware/src/lane/lane_sequencer.sv \
	$(ASIC_DIR)/ara/hardware/src/lane/operand_queue.sv \
	$(ASIC_DIR)/ara/hardware/src/lane/operand_requester.sv \
	$(ASIC_DIR)/ara/hardware/src/lane/simd_alu.sv \
	$(ASIC_DIR)/ara/hardware/src/lane/simd_div.sv \
	$(ASIC_DIR)/ara/hardware/src/lane/simd_mul.sv \
	$(ASIC_DIR)/ara/hardware/src/lane/vector_regfile.sv \
	$(ASIC_DIR)/ara/hardware/src/lane/power_gating_generic.sv \
	$(ASIC_DIR)/ara/hardware/src/lane/operand_queues_stage.sv \
	$(ASIC_DIR)/ara/hardware/src/lane/valu.sv \
	$(ASIC_DIR)/ara/hardware/src/lane/vmfpu.sv \
	$(ASIC_DIR)/ara/hardware/src/lane/fixed_p_rounding.sv \
	$(ASIC_DIR)/ara/hardware/src/lane/vector_fus_stage.sv \
	$(ASIC_DIR)/ara/hardware/src/lane/lane.sv \
	$(ASIC_DIR)/ara/hardware/src/vlsu/vlsu.sv \
	$(ASIC_DIR)/ara/hardware/src/vlsu/addrgen.sv \
	$(ASIC_DIR)/ara/hardware/src/vlsu/vldu.sv \
	$(ASIC_DIR)/ara/hardware/src/vlsu/vstu.sv \
	$(ASIC_DIR)/ara/hardware/src/sldu/sldu.sv \
	$(ASIC_DIR)/ara/hardware/src/sldu/p2_stride_gen.sv \
	$(ASIC_DIR)/ara/hardware/src/sldu/sldu_op_dp.sv \
	$(ASIC_DIR)/ara/hardware/src/masku/masku_operands.sv \
	$(ASIC_DIR)/ara/hardware/src/masku/masku.sv

INT_VERILOG_SOURCES += \
	./ara_xif_core.sv \
    ./ara_xif_wrapper.sv

# ---------- Verilator waivers (Ara/FPnew RTL); one per line to comment out when debugging ----------
IGNORE_ARGS += -Wno-UNOPTFLAT
IGNORE_ARGS += -Wno-ASCRANGE
IGNORE_ARGS += -Wno-WIDTHEXPAND
IGNORE_ARGS += -Wno-WIDTHTRUNC
IGNORE_ARGS += -Wno-ENUMVALUE
IGNORE_ARGS += -Wno-LATCH
IGNORE_ARGS += -Wno-CASEINCOMPLETE
IGNORE_ARGS += -Wno-COMBDLY
IGNORE_ARGS += -Wno-CMPCONST
IGNORE_ARGS += -Wno-UNSIGNED
IGNORE_ARGS += -Wno-SIDEEFFECT
# IGNORE_ARGS += -Wno-fatal

# Parallel Verilator C++ build (large speedup). Override with BUILD_ARGS= if needed.
BUILD_ARGS += -j$(shell nproc 2>/dev/null || echo 8)

ifeq ($(SIM),icarus)
INT_VERILOG_SOURCES := ./ara_xif_wrapper.v
EXT_VERILOG_SOURCES :=
endif

include $(RTLFLO_PATH)/cocotb_helper.mak

# ARA_SV2V_DEFINES := NR_LANES=2 VLEN=128 ARIANE_ACCELERATOR_PORT=1 COMMON_CELLS_ASSERTS_OFF VERILATOR
SV2V_STRIP_DPI := $(RTLFLO_PATH)/scripts/strip_dpi_verilog.py
SV2V_FIX_CONSTFUNC := $(RTLFLO_PATH)/scripts/fix_fpnew_constfunc_verilog.py

sv2v: $(SV2V_STRIP_DPI) $(SV2V_FIX_CONSTFUNC)
	sv2v \
        $(addprefix -I, $(VERILOG_INCLUDE_DIRS)) \
        $(addprefix -D, $(DEFINES)) -DVERILATOR \
		--top $(TOPLEVEL) $(EXT_VERILOG_SOURCES)  $(INT_VERILOG_SOURCES) \
        --write=ara_xif_wrapper_temp.v
	python3 $(RTLFLO_PATH)/scripts/strip_dpi_verilog.py ara_xif_wrapper_temp.v ara_xif_wrapper.v
	python3 $(RTLFLO_PATH)/scripts/fix_fpnew_constfunc_verilog.py ara_xif_wrapper.v
	@rm -f ara_xif_wrapper_temp.v 


