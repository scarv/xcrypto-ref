
# Import Yosys TCL commands
yosys -import

#
# Prepares the ISE model for use with the formal flow by performing some
# basic synthesis / lowering on it.
#
# Useful as the model takes a long time to synthesis like this, so doing it
# once and then sharing the prepped file is useful.
#

# Read in the design
read_verilog -I$::env(XC_WORK) $::env(REPO_HOME)/verif/model/model_ise.v

# Lower processes/tasks/functions to netlist level
procs

# Basic optimisation loop
opt

# Write out the synthesised verilog
write_verilog $::env(XC_WORK)/model_ise_prep.v
