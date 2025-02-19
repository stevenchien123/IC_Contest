set top JAM

#Read All Files
read_file -format verilog  ../src/${top}.v
#read_file -format sverilog  JAM.v
current_design [get_designs ${top}]
link

#Setting Clock Constraints
source -echo -verbose ../script/${top}.sdc
check_design
set high_fanout_net_threshold 0
uniquify
set_fix_multiple_port_nets -all -buffer_constants [get_designs *]

#Synthesis all design
compile -map_effort high -area_effort high
#compile -map_effort high -area_effort high -inc
#compile_ultra

write -format ddc     -hierarchy -output "${top}_syn.ddc"
write_sdf -version 1.0 -context verilog  ../syn/${top}_syn.sdf
write -format verilog -hierarchy -output ../syn/${top}_syn.v
report_area > area.log
report_timing > timing.log
report_qor   >  ${top}_syn.qor
