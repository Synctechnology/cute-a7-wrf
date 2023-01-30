open_project [lindex $argv 0]
reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1
set result [get_property STATUS [get_runs synth_1]]
set keyword [lindex [split $result  ] end]
if { $keyword != "Complete!" } {
exit 1
}
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
set result [get_property STATUS [get_runs impl_1]]
set keyword [lindex [split $result  ] end]
if { $keyword != "Complete!" } {
exit 1
}
exit