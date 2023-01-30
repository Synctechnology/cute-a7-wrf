write_cfgmem -force -format MCS -size 128 -interface SPIx1 -checksum -loadbit [lindex $argv 0] -file [lindex $argv 1]
