# Icarus uses a single flattened .v from sv2v. Include after cocotb_helper.mak and
# a suite-local `sv2v` recipe (PHONY or file target).
#
# Requires: TOPLEVEL, and `make sv2v` in the suite Makefile.
ifeq ($(SIM),icarus)
ICARUS_NETLIST ?= ./$(TOPLEVEL).v
sim: $(ICARUS_NETLIST)
$(ICARUS_NETLIST):
	@$(MAKE) --no-print-directory sv2v
endif