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

# Add Register File Sources

# Add Instruct Mem Sources

# Add Data Mem Sources

# Add Program Counter Sources

# Add Lib Sources

# Add Processor Sources

# Set top level module
#set_property top alu [current_fileset]
update_compile_order -fileset sources_1

set end_time [clock seconds]
puts "Project creation complete in [expr ($end_time - $start_time)] seconds!"