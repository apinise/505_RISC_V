set start_time [clock seconds]

set PROJ_NAME 505_RISC_V

# Set up directories
set CURR_DIR [pwd]
if (![regexp 505_RISC_V $CURR_DIR]) {
	puts "505_RISC_V directory not found"
	return -1
}

set BASE_DIR [regsub (505_RISC_V.*$) $CURR_DIR 505_RISC_V]
source $BASE_DIR/project/scripts/define_directories.tcl

set buildLog build.log

puts "Starting $PROJ_NAME_VIVADO project creation..."
if {[catch close_project]} {
}

# Clean Build Directory
if {[file isdirectory $WORK_DIR]} {
	file delete -force -- $WORK_DIR
}

# Create Output Build Directory
#file mkdir $WORK_DIR

# Start build log
set buildLogId [open $buildLog "w"]
puts $buildLogId "$PROJ_NAME_VIVADO Build Starting"

# Create Project
create_project ${PROJ_NAME_VIVADO} ${WORK_DIR} -part xc7a35tcpg236-1
set_param synth.elaboration.rodinMoreOptions "rt::set_parameter var_size_limit 1048576"

# Add Constraints
add_files -fileset constrs_1 -norecurse [glob $CONSTRAINT_DIR/*.xdc]

# Add ALU Sources
add_files $HDL_DIR/alu/alu.sv
add_files $HDL_DIR/alu/multiplier.sv

# Add Branch Sources
add_files $HDL_DIR/branch_comp/branch_comp.sv

# Add Register File Sources
add_files $HDL_DIR/reg_gp/register_file.sv

# Add Instruct Mem Sources
add_files $HDL_DIR/instruct_mem/instruct_mem.sv

# Add Data Mem Sources
add_files $HDL_DIR/data_mem/data_mem.sv
add_files $HDL_DIR/data_mem/data_mem_ctrl.sv
add_files $HDL_DIR/data_mem/data_mem_lw.sv
add_files $HDL_DIR/data_mem/data_mem_sw.sv

# Add Program Counter Sources
add_files $HDL_DIR/program_counter/program_counter.sv
add_files $HDL_DIR/program_counter/program_counter_add.sv
add_files $HDL_DIR/program_counter/program_counter_top.sv

# Add Lib Sources
add_files $HDL_DIR/lib/mux2to1.sv
add_files $HDL_DIR/lib/mux3to1.sv

# Add Processor Sources
add_files $HDL_DIR/proc/core.sv
add_files $HDL_DIR/proc/proc_top.sv

# Add Ctrl Logic Sources
add_files $HDL_DIR/ctrl_logic/ctrl_logic.sv

# Add Immediate Gen Sources
add_files $HDL_DIR/immediate_gen/imm_gen.sv

# Set top level module
set_property top proc_top [current_fileset]
update_compile_order -fileset sources_1

set end_time [clock seconds]
puts "Project creation complete in [expr ($end_time - $start_time)] seconds!"