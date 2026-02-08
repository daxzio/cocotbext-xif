# CocoTB test for PULP Ara vector unit only. XIF at top (ara_xif_wrapper -> ara_xif_core -> ara + axi_zero_mem).
# Explicit file list: only what the coprocessor needs. No generated .mak.
SIM ?= verilator
export SIM
TOPLEVEL_LANG = verilog
WORK_BASE ?= ..
ARA_ROOT ?= ../rtl/ara
ARA_HW := $(CURDIR)/$(ARA_ROOT)/hardware

TOPLEVEL = ara_xif_wrapper
MODULE = test_dut

# ---------- Include dirs (coprocessor only) ----------
VERILOG_INCLUDE_DIRS += \
	$(ARA_HW)/deps/common_cells/include \
	$(ARA_HW)/deps/axi/include \
	$(ARA_HW)/deps/cva6/core/include \
	$(ARA_HW)/include

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
	$(ARA_HW)/deps/cva6/core/include/config_pkg.sv \
	$(ARA_HW)/deps/cva6/core/include/cv64a6_imafdcv_sv39_config_pkg.sv \
	$(ARA_HW)/deps/cva6/core/include/riscv_pkg.sv \
	$(ARA_HW)/deps/cva6/core/include/ariane_pkg.sv \
	$(ARA_HW)/deps/cva6/core/include/build_config_pkg.sv \
	$(ARA_HW)/deps/cva6/core/serdiv.sv

# ---------- AXI (pkg + intf for types; axi_cut, axi_to_detailed_mem, axi_zero_mem) ----------
EXT_VERILOG_SOURCES += \
	$(ARA_HW)/deps/axi/src/axi_pkg.sv \
	$(ARA_HW)/deps/axi/src/axi_intf.sv \
	$(ARA_HW)/deps/axi/src/axi_cut.sv \
	$(ARA_HW)/deps/axi/src/axi_to_detailed_mem.sv \
	$(ARA_HW)/deps/axi/src/axi_zero_mem.sv

# ---------- Common cells (from hierarchy + packages/deps needed by above) ----------
COMMON_CELLS := $(ARA_HW)/deps/common_cells
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
FPNEW := $(ARA_HW)/deps/fpnew
FPDS := $(ARA_HW)/deps/fpu_div_sqrt_mvp
TC := $(ARA_HW)/deps/tech_cells_generic
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
	$(ARA_HW)/include/rvv_pkg.sv \
	$(ARA_HW)/include/ara_pkg.sv \
	$(ARA_HW)/tb/ara_xif_core.sv \
	$(ARA_HW)/src/segment_sequencer.sv \
	$(ARA_HW)/src/ctrl_registers.sv \
	$(ARA_HW)/src/cva6_accel_first_pass_decoder.sv \
	$(ARA_HW)/src/ara_dispatcher.sv \
	$(ARA_HW)/src/ara_sequencer.sv \
	$(ARA_HW)/src/ara.sv \
	$(ARA_HW)/src/lane/lane_sequencer.sv \
	$(ARA_HW)/src/lane/operand_queue.sv \
	$(ARA_HW)/src/lane/operand_requester.sv \
	$(ARA_HW)/src/lane/simd_alu.sv \
	$(ARA_HW)/src/lane/simd_div.sv \
	$(ARA_HW)/src/lane/simd_mul.sv \
	$(ARA_HW)/src/lane/vector_regfile.sv \
	$(ARA_HW)/src/lane/power_gating_generic.sv \
	$(ARA_HW)/src/lane/operand_queues_stage.sv \
	$(ARA_HW)/src/lane/valu.sv \
	$(ARA_HW)/src/lane/vmfpu.sv \
	$(ARA_HW)/src/lane/fixed_p_rounding.sv \
	$(ARA_HW)/src/lane/vector_fus_stage.sv \
	$(ARA_HW)/src/lane/lane.sv \
	$(ARA_HW)/src/vlsu/vlsu.sv \
	$(ARA_HW)/src/vlsu/addrgen.sv \
	$(ARA_HW)/src/vlsu/vldu.sv \
	$(ARA_HW)/src/vlsu/vstu.sv \
	$(ARA_HW)/src/sldu/sldu.sv \
	$(ARA_HW)/src/sldu/p2_stride_gen.sv \
	$(ARA_HW)/src/sldu/sldu_op_dp.sv \
	$(ARA_HW)/src/masku/masku_operands.sv \
	$(ARA_HW)/src/masku/masku.sv

INT_VERILOG_SOURCES += ./ara_xif_wrapper.sv

# Full source list for Verilator (used by hierarchy target; unchanged by SIM=icarus)
ARA_VERILATOR_SOURCES := $(INT_VERILOG_SOURCES) $(EXT_VERILOG_SOURCES)

# ---------- Icarus: use single .v from sv2v; run 'make sv2v' first ----------
ARA_SV_FOR_SV2V := $(EXT_VERILOG_SOURCES) $(INT_VERILOG_SOURCES)
ifeq ($(SIM),icarus)
INT_VERILOG_SOURCES := ./ara_xif_wrapper.v
EXT_VERILOG_SOURCES :=
endif

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

# Disable waves by default for faster builds; use WAVES=1 when debugging.
WAVES ?= 0

include $(WORK_BASE)/rtlflo/cocotb_helper.mak

# ---------- sv2v: convert all Ara SV to one Verilog file for Icarus ----------
.PHONY: sv2v
sv2v: ara_xif_wrapper.v

# Defines for sv2v (same as RTL; VERILATOR strips assertion blocks in AXI RTL)
ARA_SV2V_DEFINES := NR_LANES=2 VLEN=128 ARIANE_ACCELERATOR_PORT=1 COMMON_CELLS_ASSERTS_OFF VERILATOR

ara_xif_wrapper.v: $(ARA_SV_FOR_SV2V)
	sv2v $(addprefix -I, $(VERILOG_INCLUDE_DIRS)) $(addprefix -D, $(ARA_SV2V_DEFINES)) \
		--top $(TOPLEVEL) $(ARA_SV_FOR_SV2V) --write=ara_xif_wrapper.v

# Icarus: sim.vvp depends on sv2v-generated .v
ifeq ($(SIM),icarus)
$(SIM_BUILD)/sim.vvp: ara_xif_wrapper.v
# Remind if .v is missing (e.g. sv2v not run or failed on Ara RTL)
_icarus_check := $(if $(wildcard ara_xif_wrapper.v),,$(warning Run 'make sv2v' first. If sv2v fails, Ara RTL may use SV that sv2v does not support; use SIM=verilator or fix the reported file.))
endif

# ---------- Hierarchy: instance name, module type, source file (Verilator --json-only) ----------
HIERARCHY_DIR := .hierarchy
HIERARCHY_JSON := $(HIERARCHY_DIR)/V$(TOPLEVEL).tree.json
HIERARCHY_META := $(HIERARCHY_DIR)/V$(TOPLEVEL).tree.meta.json

.PHONY: hierarchy
hierarchy: $(HIERARCHY_JSON)
	python3 $(WORK_BASE)/rtlflo/scripts/verilator_hierarchy.py $(HIERARCHY_JSON) $(HIERARCHY_META) --top $(TOPLEVEL)

$(HIERARCHY_JSON): $(ARA_VERILATOR_SOURCES)
	@mkdir -p $(HIERARCHY_DIR)
	verilator --json-only -Mdir $(HIERARCHY_DIR) --top-module $(TOPLEVEL) \
		$(VINCLUDE_ARGS) $(addprefix -D, $(DEFINES)) $(IGNORE_ARGS) \
		$(ARA_VERILATOR_SOURCES)
