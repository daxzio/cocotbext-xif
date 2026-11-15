# Out-of-context Horcrux coprocessor: utilization after route, no bitstream.
SYNTH_TOP:=horcrux_xif_wrapper

XILINX_PART:=xc7a100tcsg324-1
XILINX_REV?=2025.1

BUILD_NAME:=${SYNTH_TOP}

XILINX_CONSTRAINTS += \
    $(CURDIR)/constraints/clk.xdc

VIVADO_TO_STEP := route_design

# Block-level numbers: do not pack XIF ports into IOBs.
XILINX_PRE_CUSTOM += \
    set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-mode out_of_context} -objects [get_runs synth_1];
