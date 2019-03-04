
# Import Yosys TCL commands
yosys -import

# Read in the design
read_verilog -I$::env(XC_WORK) $::env(REPO_HOME)/rtl/coprocessor/*
read_verilog                   $::env(REPO_HOME)/extern/picorv32/picorv32.v
read_verilog -I$::env(XC_WORK) $::env(REPO_HOME)/rtl/integration/*

# Synthesise processes ready for SCC check.
procs

# Check that there are no logic loops in the design early on.
tee -o $::env(XC_WORK)/logic-loops.rpt check -assert

# Generic yosys synthesis command
synth -top scarv_prv_xcrypt_top

# Print some statistics out
tee -o $::env(XC_WORK)/synth-statistics.rpt stat -width

# Write out the synthesised verilog
write_verilog $::env(XC_WORK)/scarv_cop_top.v
