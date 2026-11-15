CPUIF ?= apb4-flat
ETANA_ARGS ?= --in-str i --out-str o --default-reset arst_n --flatten-nested-blocks --hwif-report
UDPS ?= regblock_udps.rdl

.PHONY: etana
etana:
	peakrdl etana $(UDPS) horcrux_regs.rdl --top HORCRUX_REGS --rename horcrux_regs_apb4 \
		--cpuif $(CPUIF) -o . $(ETANA_ARGS)
