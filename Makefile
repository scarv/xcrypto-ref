
ifndef REPO_HOME
    $(error "Please run 'source ./bin/conf.sh' to setup the project workspace")
endif

PARSE_OPCODES = $(REPO_HOME)/extern/riscv-opcodes/parse-opcodes
OPCODES_SPEC  = $(REPO_HOME)/extern/riscv-opcodes/opcodes-xcrypto
RTL_DECODER   = $(XC_WORK)/ise_decode.v

UNIT_TESTS    = $(shell find . -path "./build/unit/*.hex")
UNIT_WAVES    = $(UNIT_TESTS:%.hex=%.vcd)

FORMAL_CHECKS = $(shell find ./verif/formal -name "fml_chk_*.v")
FORMAL_CHECK_NAMES = $(basename $(notdir $(FORMAL_CHECKS)))

export BMC_STEPS     ?= 10

export FML_CHECK_NAME = $(subst fml_chk_,,$(FORMAL_CHECK_NAMES))
export FML_ENGINE     = boolector

export SIM_UNIT_TEST ?= $(XC_WORK)/unit/00-mvcop.hex
export RTL_TIMEOUT   ?= 300

export VERILATOR_SIM ?= $(XC_WORK)/verilator/scarv_prv_xcrypt_top

#
# Should be either "riscv" or "riscv-xcrypto"
#
export LIBSCARV_ARCH ?= riscv-xcrypto

.PHONY: doc
doc:
	$(MAKE) -C $(REPO_HOME)/doc all

#
# Build all of the assembly level examples of the ISE instructions
# into hex files. These can then be fed into the HDL simulator.
#
.PHONY: example
example: libscarv
	$(MAKE) -C $(REPO_HOME)/example all

.PHONY: libscarv
libscarv: 
	$(MAKE) -C $(LIBSCARV) ARCH=$(LIBSCARV_ARCH) all

libscarv-clean:
	$(MAKE) -C $(LIBSCARV) ARCH=$(LIBSCARV_ARCH) clean


.PHONY: benchmarks
benchmarks: libscarv example verilator_build
	$(MAKE) -C $(REPO_HOME)/flow/benchmarks all

.PHONY: benchmarks-clean
benchmarks-clean:
	$(MAKE) -C $(REPO_HOME)/flow/benchmarks clean


.PHONY: clean
clean: libscarv-clean benchmarks-clean
	$(MAKE) -C $(REPO_HOME)/doc     clean
	$(MAKE) -C $(REPO_HOME)/example clean
	$(MAKE) -C $(REPO_HOME)/verif/unit clean
	$(MAKE) -C $(REPO_HOME)/flow/icarus clean
	$(MAKE) -C $(REPO_HOME)/flow/yosys clean
	rm -f $(RTL_DECODER)


#
# Generate verilog code for the ISE instruction decoder.
#
.PHONY: rtl_decoder
rtl_decoder: $(RTL_DECODER)
$(RTL_DECODER) : $(OPCODES_SPEC) $(PARSE_OPCODES)
	cat $< | python3 $(PARSE_OPCODES) -verilog > $@


#
# Run the yosys formal flow
#
.PHONY: yosys_formal
yosys_formal: $(RTL_DECODER)
	$(MAKE) -C $(REPO_HOME)/flow/yosys formal-checks

#
# Synthesis the verilog design using yosys
#
.PHONY: yosys_synth
yosys_synth: $(RTL_DECODER)
	$(MAKE) -C $(REPO_HOME)/flow/yosys synthesise

#
# Build the Icarus Verilog based simulation model
#
.PHONY: icarus_build
icarus_build: $(RTL_DECODER)
	$(MAKE) -C $(REPO_HOME)/flow/icarus sim

#
# Run the icarus based simulation model, accounting for the RTL_TIMEOUT
# and SIM_UNIT_TEST variables at the top of this file.
#
.PHONY: icarus_run
icarus_run: icarus_build unit_tests
	$(MAKE) -C $(REPO_HOME)/flow/icarus run

#
# Run icaurus model on all unit tests
#
.PHONY: icarus_run_all
icarus_run_all : $(UNIT_WAVES) unit_tests

./build/unit/%.vcd : $(XC_WORK)/unit/%.hex icarus_build
	$(MAKE) -C $(REPO_HOME)/flow/icarus run \
        SIM_UNIT_TEST=$< \
        SIM_LOG=$(XC_WORK)/unit/$(notdir $@).log
	@mv $(XC_WORK)/icarus/unit-waves.vcd $@

#
# Build the icarus integration testbench
#
.PHONY: icarus_integ_tb
icarus_integ_tb:
	$(MAKE) -C $(REPO_HOME)/flow/icarus integ-sim

#
# Build the icarus integration testbench
#
.PHONY: icarus_run_integ
icarus_run_integ: RTL_TIMEOUT = 3000
icarus_run_integ: example
icarus_run_integ: icarus_integ_tb
	$(MAKE) -C $(REPO_HOME)/flow/icarus integ-run

#
# Build the ISE unit tests into hex files for use with the Icarus
# simulation model.
#
.PHONY: unit_tests
unit_tests:
	$(MAKE) -C $(REPO_HOME)/verif/unit all

.PHONY: verilator_build
verilator_build: rtl_decoder
	$(MAKE) -C $(REPO_HOME)/flow/verilator build

verilator_run: RTL_TIMEOUT=3000
verilator_run:
	$(MAKE) -C $(REPO_HOME)/flow/verilator run

#
# Build the unit tests, examples yosys and icarus models but don't run 
# anything yet.
#
build_all: libscarv icarus_build unit_tests icarus_integ_tb example doc verilator_build
