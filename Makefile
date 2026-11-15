# Aggregate cocotb suite runs from the repo root.
# Activate the project venv first: source ~/.venv/horcrux-3.13.5/bin/activate

SIM ?= verilator
WAVES ?= 0

XIF_SUITES := \
	test_xif_copro \
	test_fpu_ss \
	test_horcrux \
	test_horcrux_apb \
	test_ara

.PHONY: default sim verilator icarus clean $(XIF_SUITES)

default: sim

# Verilator is the primary flow. tests/test_ara pins VERILATOR_BIN_DIR to spack
# 5.050 in its Makefile (5.052+ OOM in ConstVisitor on Ara). Other suites use
# Verilator from PATH. See tests/test_ara/VERILATOR-5.052.md.
sim verilator: $(XIF_SUITES)

icarus:
	$(MAKE) sim SIM=icarus

define run_xif_suite
	@echo "=== tests/$(1) SIM=$(SIM) WAVES=$(WAVES) ==="
	cd tests/$(1) && $(MAKE) clean sim SIM=$(SIM) WAVES=$(WAVES) && ../rtlflo/combine_results.py
endef

test_xif_copro:
	$(call run_xif_suite,test_xif_copro)

test_fpu_ss:
	$(call run_xif_suite,test_fpu_ss)

test_horcrux:
	$(call run_xif_suite,test_horcrux)

test_horcrux_apb:
	$(call run_xif_suite,test_horcrux_apb)

test_ara:
	$(call run_xif_suite,test_ara)

# CI and legacy entry point (replaced old APB-style test dirs).
verilog: sim

clean:
	@for d in $(XIF_SUITES); do \
		echo "=== clean tests/$$d ==="; \
		$(MAKE) -C tests/$$d clean; \
	done

lint:
	pyflakes cocotbext
	ruff check cocotbext

mypy:
	mypy cocotbext

format:
	black cocotbext

checks: format lint mypy

dist:
	rm -rf MANIFEST
	rm -rf CHANGELOG.txt
	python setup.py sdist

pre-commit:
	pre-commit run --all-files

GIT_TAG?=0.0.1
VERSION_FILE?=`find cocotbext -name version.py`
release:
	echo "Release v${GIT_TAG}"
# 	@grep -Po '\d\.\d\.\d' cocotbext/jtag/version.py
	git tag v${GIT_TAG} || { echo "make release GIT_TAG=0.0.5"; git tag ; exit 1; }
	echo "__version__ = \"${GIT_TAG}\"" > ${VERSION_FILE}
	git add ${VERSION_FILE}
	git commit --allow-empty -m "Update to version ${GIT_TAG}"
	git tag -f v${GIT_TAG}
	git push && git push --tags

git_align:
	mkdir -p repos
	cd repos ; git clone git@github.com:daxzio/rtlflo.git 2> /dev/null || (cd rtlflo ; git pull)
	rsync -artu --exclude .git repos/rtlflo/ tests/rtlflo
	rsync -artu --exclude .git tests/rtlflo/ repos/rtlflo