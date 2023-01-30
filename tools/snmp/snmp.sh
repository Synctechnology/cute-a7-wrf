#!/bin/sh
#snmpget -v 2c -c public -m WR-WRPC-MIB -M +./ 192.168.0.5 wrpcPtpClockOffsetPsHR.0
snmpwalk -v 2c -c public -m WR-WRPC-MIB -M +./ 192.168.0.5 wrpcCore
