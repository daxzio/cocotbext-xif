SYNTH_TOP?=hazard3_c7

# CONFIG?=default
# YOSYS_CMDS += -DCONFIG_HEADER='config_$(CONFIG).vh'

ifdef DEFINES
	YOSYS_CMDS += $(addprefix -D, $(DEFINES))
endif
ifdef VERILOG_INCLUDE_DIRS
    YOSYS_CMDS += $(addprefix -I, $(VERILOG_INCLUDE_DIRS))
endif


yosys:
	yosys -p "\
		read_verilog -sv ${YOSYS_CMDS} ${VERILOG_DESIGN} ; \
        synth_xilinx -edif ${SYNTH_TOP}.edif -top ${SYNTH_TOP} ; \
	"
# 	yosys -p "\
# 		read_verilog -sv ${YOSYS_CMDS} ${VERILOG_DESIGN} ; \
# 		hierarchy -top ${SYNTH_TOP}; \
# 		proc; \
# 		flatten; \
# 		synth ; \
#         synth_xilinx -edif ${SYNTH_TOP}.edif ; \
# 		write_verilog ${SYNTH_TOP}_synth.v ; \
# 	"

clean::
	rm -rf ${SYNTH_TOP}_synth.v
