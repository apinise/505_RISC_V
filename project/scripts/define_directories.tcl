############################
# Define working directories
############################
puts "Defining Directories and Checking Script Environment"

if (![info exists PROJ_NAME]) {
	error "PROJ_NAME variable has not been set"
}

set CURR_DIR [pwd]
if (![regexp 505_RISC_V $CURR_DIR]) {
	error "505_RISC_V root direcotry not found"
}

# Set Variables
set GIT_DIR [regsub (505_RISC_V.*$) $CURR_DIR 505_RISC_V]
set PROJ_DIR $GIT_DIR/project
set SCRIPT_DIR $PROJ_DIR/scripts
# set MEM_DIR $PROJ_DIR/Mem_Files
set CONSTRAINT_DIR $PROJ_DIR/constraint
set WORK_DIR $PROJ_DIR/work

set HDL_DIR $GIT_DIR/hdl
# set BD_DIR $GIT_DIR/BD

# Set Vivado Directories
set PROJ_NAME_VIVADO ${PROJ_NAME}_prj
set BUILD_FOLDER_NAME work
set RELEASE_STATUS dev