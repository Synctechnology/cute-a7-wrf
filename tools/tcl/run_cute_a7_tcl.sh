#!/bin/bash

set -e
test -d $XILINX
echo "${1}"
if [ "${1}" = "compile_project" ]; then
	vivado -nojournal -nolog -mode batch -source ./tools/tcl/compile_project.tcl -tclargs ${2}
fi

if [ "${1}" = "generate_mcs" ]; then
	vivado -nojournal -nolog -mode batch -source ./tools/tcl/generate_mcs.tcl -tclargs "UP 0X0 ${2}" ${3}
fi

if [ "${1}" = "program_fpga" ]; then
	vivado -nojournal -nolog -mode batch -source ./tools/tcl/program_fpga.tcl -tclargs ${2}
fi

if [ "${1}" = "program_flash" ]; then
	vivado -nojournal -nolog -mode batch -source ./tools/tcl/program_flash.tcl -tclargs ${2}
fi

