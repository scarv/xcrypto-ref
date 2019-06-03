
# Import Yosys TCL commands
yosys -import

# Read in the design
read_verilog -I$::env(XC_WORK) $::env(REPO_HOME)/rtl/coprocessor/*

# Synthesise processes ready for SCC check.
procs

# Check that there are no logic loops in the design early on.
tee -o $::env(XC_WORK)/logic-loops.rpt check -assert

# Generic yosys synthesis command
synth -top scarv_cop_top

# Print some statistics out
tee -o $::env(XC_WORK)/synth-statistics.rpt stat -width

# Write out the synthesised verilog
write_verilog $::env(XC_WORK)/synth-cells.v

dfflibmap -liberty $::env(YOSYS_ROOT)/techlibs/common/cells.lib
abc -liberty $::env(YOSYS_ROOT)/examples/cmos/cmos_cells.lib
tee -o $::env(XC_WORK)/synth-gates.rpt stat

write_verilog $::env(XC_WORK)/synth.v

