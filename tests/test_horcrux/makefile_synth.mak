SYNTH_TOP?=horcrux_xif_wrapper

XILINX_PART?=xc7a100tcsg324-1
XILINX_REV?=2025.1

ifneq (,$(wildcard ./makefile_synth_local.mak))
    include ./makefile_synth_local.mak
endif
BUILD_NAME?=${SYNTH_TOP}
