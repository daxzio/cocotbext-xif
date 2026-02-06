ifdef VERILOG_INCLUDE_DIRS
  VINCLUDE_ARGS += $(addprefix +incdir+, $(VERILOG_INCLUDE_DIRS))
endif

vlint:
	verilator --lint-only \
		${VINCLUDE_ARGS} \
    	${IGNORE_ARGS} \
		$(INT_VERILOG_SOURCES) $(SIM_VERILOG_SOURCES) $(EXT_VERILOG_SOURCES) \
        --top-module ${TOPLEVEL}

