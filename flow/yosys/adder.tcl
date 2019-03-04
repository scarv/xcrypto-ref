
# Import Yosys TCL commands
yosys -import

# Read the design
read_verilog -formal $::env(REPO_HOME)/rtl/coprocessor/scarv_cop_palu_adder.v

# Dump pre-synthesis schematic to file
show -format svg -prefix $::env(XC_WORK)/adder-schematic-bhav.svg

# Processes / generates into netlist
procs;

# generic synthsis
synth;

# Dump post-synthesis schematic to file
show -format svg -prefix $::env(XC_WORK)/adder-schematic-synth.svg

# Dump SMT2 model
write_smt2 -wires $::env(XC_WORK)/adder.smt2

# Print stats
stat -width;

