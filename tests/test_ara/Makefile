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
	$(ASIC_DIR)/common_cells.bck/include \
	$(ASIC_DIR)/axi.bck/include \
	$(ASIC_DIR)/cva6.bck/core/include \
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
	$(ASIC_DIR)/cva6/include/config_pkg.sv \
	$(ASIC_DIR)/cva6/include/cv64a6_imafdcv_sv39_config_pkg.sv \
	$(ASIC_DIR)/cva6/include/riscv_pkg.sv \
	$(ASIC_DIR)/cva6/include/ariane_pkg.sv \
	$(ASIC_DIR)/cva6/include/build_config_pkg.sv \
	$(ASIC_DIR)/cva6/serdiv.sv

# ---------- AXI (pkg + intf for types; axi_cut, axi_to_detailed_mem, axi_zero_mem) ----------
EXT_VERILOG_SOURCES += \
	$(ASIC_DIR)/axi/axi_pkg.sv \
	$(ASIC_DIR)/axi/axi_intf.sv \
	$(ASIC_DIR)/axi/axi_cut.sv \
	$(ASIC_DIR)/axi/axi_to_detailed_mem.sv \
	$(ASIC_DIR)/axi/axi_zero_mem.sv

# ---------- Common cells (from hierarchy + packages/deps needed by above) ----------
EXT_VERILOG_SOURCES += \
	$(ASIC_DIR)/common_cells/cf_math_pkg.sv \
	$(ASIC_DIR)/common_cells/spill_register.sv \
	$(ASIC_DIR)/common_cells/spill_register_flushable.sv \
	$(ASIC_DIR)/common_cells/stream_fifo.sv \
	$(ASIC_DIR)/common_cells/stream_fork.sv \
	$(ASIC_DIR)/common_cells/stream_fork_dynamic.sv \
	$(ASIC_DIR)/common_cells/stream_join.sv \
	$(ASIC_DIR)/common_cells/stream_join_dynamic.sv \
	$(ASIC_DIR)/common_cells/stream_to_mem.sv \
	$(ASIC_DIR)/common_cells/stream_mux.sv \
	$(ASIC_DIR)/common_cells/stream_demux.sv \
	$(ASIC_DIR)/common_cells/stream_xbar.sv \
	$(ASIC_DIR)/common_cells/stream_intf.sv \
	$(ASIC_DIR)/common_cells/mem_to_banks_detailed.sv \
	$(ASIC_DIR)/common_cells/lzc.sv \
	$(ASIC_DIR)/common_cells/popcount.sv \
	$(ASIC_DIR)/common_cells/fifo_v3.sv \
	$(ASIC_DIR)/common_cells/delta_counter.sv \
	$(ASIC_DIR)/common_cells/counter.sv \
	$(ASIC_DIR)/common_cells/fall_through_register.sv

# ---------- FPnew (ara_pkg + lane vmfpu), tech_cells (VRF), common_cells extras ----------
FPNEW := $(ASIC_DIR)/ara.bck/hardware/deps/fpnew
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
	$(ASIC_DIR)/fpu_div_sqrt_mvp/defs_div_sqrt_mvp.sv \
	$(ASIC_DIR)/fpu_div_sqrt_mvp/control_mvp.sv \
	$(ASIC_DIR)/fpu_div_sqrt_mvp/preprocess_mvp.sv \
	$(ASIC_DIR)/fpu_div_sqrt_mvp/iteration_div_sqrt_mvp.sv \
	$(ASIC_DIR)/fpu_div_sqrt_mvp/norm_div_sqrt_mvp.sv \
	$(ASIC_DIR)/fpu_div_sqrt_mvp/nrbd_nrsc_mvp.sv \
	$(ASIC_DIR)/fpu_div_sqrt_mvp/div_sqrt_mvp_wrapper.sv \
	$(ASIC_DIR)/fpu_div_sqrt_mvp/div_sqrt_top_mvp.sv \
	$(ASIC_DIR)/tech_cells_generic/tc_sram.sv \
	$(ASIC_DIR)/tech_cells_generic/tc_sram_impl.sv \
	$(ASIC_DIR)/tech_cells_generic/tc_clk.sv \
	$(ASIC_DIR)/common_cells/stream_register.sv \
	$(ASIC_DIR)/common_cells/rr_arb_tree.sv \
	$(ASIC_DIR)/common_cells/mem_to_banks.sv

# ---------- Ara coprocessor RTL (from hierarchy, deduplicated) ----------
# ara_dispatcher: path factored out so sv2v can use a patched copy (enum .next on
# type-parameter fields is not yet rewritten by sv2v).
ARA_DISPATCHER_SRC := $(ASIC_DIR)/ara/hardware/src/ara_dispatcher.sv
EXT_VERILOG_SOURCES += \
	$(ASIC_DIR)/ara/hardware/include/rvv_pkg.sv \
	$(ASIC_DIR)/ara/hardware/include/ara_pkg.sv \
	$(ASIC_DIR)/ara/hardware/src/segment_sequencer.sv \
	$(ASIC_DIR)/ara/hardware/src/ctrl_registers.sv \
	$(ASIC_DIR)/ara/hardware/src/cva6_accel_first_pass_decoder.sv \
	$(ARA_DISPATCHER_SRC) \
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

# Snapshot full SV lists for sv2v before Icarus replaces them with the flat .v.
SV2V_EXT_SOURCES := $(EXT_VERILOG_SOURCES)
SV2V_INT_SOURCES := $(INT_VERILOG_SOURCES)

# Icarus: single .v from sv2v (run "make sv2v" first). Override before include so VERILOG_DESIGN is correct.
ifeq ($(SIM),icarus)
INT_VERILOG_SOURCES := ./ara_xif_wrapper.v
EXT_VERILOG_SOURCES :=
endif

include $(RTLFLO_PATH)/cocotb_helper.mak

# Icarus sim needs ara_xif_wrapper.v; rebuild via make sv2v when missing/outdated.
ifeq ($(SIM),icarus)
sim_build_icarus/sim.vvp: ara_xif_wrapper.v
endif

# Local sv2v with enum-method support (override if needed).
SV2V ?= /mnt/sda/projects/sv2v/bin/sv2v

# sv2v cannot yet rewrite enum methods on fields of type-parameter types
# (ara_req_t.emul.next). Use next_lmul(), which matches .next() for legal LMULs.
ARA_DISPATCHER_SV2V := ara_dispatcher_sv2v.sv
$(ARA_DISPATCHER_SV2V): $(ARA_DISPATCHER_SRC)
	sed 's/ara_req\.emul\.next()/next_lmul(ara_req.emul)/g' $< > $@

SV2V_SOURCES := $(patsubst $(ARA_DISPATCHER_SRC),$(ARA_DISPATCHER_SV2V),$(SV2V_EXT_SOURCES) $(SV2V_INT_SOURCES))

sv2v: $(ARA_DISPATCHER_SV2V)
	$(SV2V) \
		$(addprefix -I, $(VERILOG_INCLUDE_DIRS)) \
		$(addprefix -D, $(DEFINES)) -DVERILATOR \
		--top $(TOPLEVEL) $(SV2V_SOURCES) \
		--write=ara_xif_wrapper.v
	python3 post_sv2v_icarus.py ara_xif_wrapper.v

.PHONY: sv2v
clean::
	rm -f $(ARA_DISPATCHER_SV2V)

