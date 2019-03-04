
# Import Yosys TCL commands
yosys -import

# Read in the design
read_verilog -formal \
    -I$::env(XC_WORK) \
    -I$::env(REPO_HOME)/verif/formal \
      $::env(REPO_HOME)/rtl/coprocessor/*;

# Top level formal testbench.
read_verilog -formal \
    -I$::env(XC_WORK) \
    -I$::env(REPO_HOME)/rtl/coprocessor \
      $::env(REPO_HOME)/verif/formal/*.v;

read_verilog -formal \
    -I$::env(XC_WORK) \
    -I$::env(REPO_HOME)/verif/formal \
      $::env(REPO_HOME)/verif/tb/tb_formal.v;

# Get setup to use the yosys_tb as the top module. The -nordff flag stops
# the memory_dff command (run as part of prep) from merging flipflops into
# memory read ports.
prep -top tb_formal;

