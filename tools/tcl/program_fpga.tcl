open_hw
connect_hw_server
current_hw_target
open_hw_target
current_hw_device [lindex [get_hw_devices] 0]
puts "[lindex $argv 0] is programmed to FPGA"
set_property PROGRAM.FILE [lindex $argv 0] [current_hw_device]
program_hw_devices [current_hw_device]
quit