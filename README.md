# [XCrypto](https://github.com/scarv/xcrypto): reference implementation

<!--- -------------------------------------------------------------------- --->

[![Build Status](https://travis-ci.com/scarv/xcrypto-ref.svg)](https://travis-ci.com/scarv/xcrypto-ref)
[![Documentation](https://codedocs.xyz/scarv/xcrypto-ref.svg)](https://codedocs.xyz/scarv/xcrypto-ref)

<!--- -------------------------------------------------------------------- --->

*A component part of the
[SCARV](https://github.com/scarv)
project,
XCrypto is a general-purpose Instruction Set Extension (ISE) for
[RISC-V](https://riscv.org)
that supports software-based cryptographic workloads.
The main
[repository](https://github.com/scarv/xcrypto)
acts as a general container for associated resources;
this specific submodule houses
a formally verified, area-optimised reference implementation of XCrypto that (e.g., acting as a co-processor) can be coupled to existing RISC-V cores.*

<!--- -------------------------------------------------------------------- --->

## Organisation

```
├── bin                     - scripts (e.g., environment configuration)
├── build                   - working directory for build
├── doc                     - documentation
│   ├── tex                   - LaTeX content
│   └── image                 - image content
├── example                 - example programs
│   ├── common                - Shared files between examples
│   ├── ...                   - Multiple cryptographic algorithm examples
│   └── integration-test      - "Hello World" example integration program
├── extern                  - external resources (e.g., submodules)
│   ├── libscarv              - submodule: scarv/libscarv
│   ├── picorv32              - submodule: cliffordwolf/picorv32
│   ├── riscv-opcodes         - submodule: scarv/riscv-opcodes
│   └── texmf                 - submodule: scarv/texmf
├── flow                    - simulation and implementation flow
│   ├── gtkwave               - wave views
│   ├── benchmarks            - performance benchmarking flow
│   ├── verilator             - subsystem simulator flow
│   ├── icarus                - simulation flow
│   └── yosys                 - formal SMT2 generation and synthesis
├── rtl                     - implementation
│   ├── coprocessor           - reference implementation
│   └── integration           - reference integration (with `picorv32`)
└── verif                   - verification flow
    ├── formal                - Formal verification checks
    ├── tb                    - Simulation/integration/formal testbenches
    └── unit                  - Simulation sanity tests
```

<!--- -------------------------------------------------------------------- --->

## Quickstart

- The
  [releases](https://github.com/scarv/xcrypto-ref/releases)
  page houses pre-built content.

- You can build the content yourself: 

  1. Install any associated pre-requisites, e.g.,

     - the
       [Yosys](http://www.clifford.at/yosys)
       Verilog synthesis tool,
       exporting the
       `YOSYS_ROOT`
       environment variable st.
       `${YOSYS_ROOT}/yosys` 
       points at the 
       Yosys
       executable,
     - the 
       [Verilator](https://www.veripool.org/wiki/verilator)
       Verilog simulator tool,
       exporting the
       `${VERILATOR_ROOT}`
       environment variable st.
       `${VERILATOR_ROOT}/bin/verilator` 
       points at the 
       Verilator
       executable,
     - the 
       [SCARV-specific fork](https://github.com/scarv/riscv-tools)
       of the official RISC-V toolchain,
       exporting the
       `RISCV`
       environment variable st.
       `${RISCV}/bin/riscv64-unknown-elf-gcc` 
       points at the 
       GCC 
       executable,
     - a modern 
       [LaTeX](https://www.latex-project.org)
       distributation,
       such as
       [TeX Live](https://www.tug.org/texlive),
       including any required packages.

  2. Execute

     ```sh
     git clone https://github.com/scarv/xcrypto-ref.git
     cd ./xcrypto-ref
     git submodule update --init --recursive
     source ./bin/conf.sh
     ```

     to initialise the repository and configure the environment.

  3. Use targets in the top-level `Makefile` to build or execute
     the content, e.g.,

     - execute

       ```sh
       make doc
       ```

       to build the documentation:
       you should find that
       `${REPO_HOME}/build/doc/ref.pdf`
       has been built.

<!--- -------------------------------------------------------------------- --->

## Notes

### Running Simulations

There are two simulation testbenches for the design. The integration
testbench acts as a general ISA simulator, which allows one to write
and run C code on a PicoRV32 CPU attatched to the reference XCrypto
implementation. The second is only for testing during design and
implementaton of the RTL, and will be of little interest to those wanting
to write code for the ISE.

**Integration Tests**

These tests work as part of an example integration of the COP with the
[picorv32](https://github.com/cliffordwolf/picorv32) core.
The integrated design subsystem is found in `rtl/integration`.
It can be used to write experimental / development code without having to
have an actual hardware platform on which to implement the reference
design.

Information on how to build and use the simulation binary is found
in [$REPO_HOME/flow/verilator/README.md](./flow/verilator/README.md).

Example code to run in the integration testbench is found in 
`examples/integration-test`

**Benchmarking**

The integration testbench described in 
[$REPO_HOME/flow/verilator/README.md](./flow/verilator/README.md)
is also used to run the benchmarking programs.
More information on the benchmarking flow can be found in
[$REPO_HOME/flow/benchmarks/README.md](./flow/benchmarks/README.md).


**Unit Tests**

- These use icarus verilog, and the modified binutils to run the tests
  found in `verif/unit/`.
- These are *not* correctness/compliance tests. They are used as simple 
  sanity checks during the design cycle.
- Checking for correctness should be done using the formal flow.

Building the testbench:

```sh
$> make unit_tests      # Build the unit tests
$> make icarus_build    # Build the unit test simulation testbench
```

Running the tests:

```sh
$> make icarus_run SIM_UNIT_TEST=<file> RTL_TIMEOUT=1000
$> make icarus_run_all  # Run all unit tests as a regression
```

The `<file>` path should point at a unit-test hex file, present in
`$XC_WORK/unit/*.hex`. Using `$XC_WORK` as part of an absolute path
to the hex file is advised.

## Formal testbench

Formal checks are run using Yosys and Boolector. Checks are listed in
`verif/formal/*`. A more complete description of the formal flow can
be found toward the end of the implementation document.

To run a single check, use:

```sh
$> make yosys_formal FML_CHECK_NAME=<name>
```

where `<name>` corresponds too some file called 
`verif/formal/fml_check_<name>.v`.

To run a regression of formal checks:

```sh
$> make -j 4 yosys_formal
```

will run 4 proofs in parallel. Change this number to match the available
compute resources you have. One can also run a specfic subset of the
available formal checks by delimiting the check names with spaces, and using
a backslash to escape the spaces: `FML_CHECK_NAME=check1\ check2\ check3`.

<!--- -------------------------------------------------------------------- --->

## Acknowledgements

This work has been supported in part by EPSRC via grant 
[EP/R012288/1](https://gow.epsrc.ukri.org/NGBOViewGrant.aspx?GrantRef=EP/R012288/1),
under the [RISE](http://www.ukrise.org) programme.

<!--- -------------------------------------------------------------------- --->
