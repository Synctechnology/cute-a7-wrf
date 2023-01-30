#!/usr/bin/env python3
import serial
import time

uart_port = 0
cmd_tx = [0x7B,0x7B,0x02,0x7D,0x7D]

def cmd_decode(recv):
    if((recv[0]!=0x7B) or (recv[1]!=0x7B)):
        print("err frame head")
        return
    
    if((recv[-1]!=0x7D) or (recv[-2]!=0x7D)):
        print("err frame tail")
        return
    
    if(recv[2]==0x03):
        print(len(recv))
        for i in range(len(recv)):
            print(i,":",recv[i])

        sec = 0
        for i in range(3,11):
            sec += (recv[i] << ((i-3)*8))
        print("sec:",sec, "s")

        nsec = 0
        for i in range(11,15):
            nsec += (recv[i] << ((i-11)*8))
        print("nsec:",nsec, "ns")

        temperature = 0
        for i in range(15,17):
            temperature += (recv[i] << ((i-15)*8))
        print("temperature:",temperature ,"℃")

        link = recv[17]
        lock = recv[18]
        ptpmode = recv[19]
        ptpstate = recv[20]
        servostate = recv[21]

        delaymm = 0
        for i in range(22,29):
            delaymm += (recv[i] << ((i-22)*8))
        
        delayms = 0
        for i in range(30,37):
            delayms += (recv[i] << ((i-30)*8))

        fixdelaytxm = 0
        for i in range(38,41):
            fixdelaytxm += (recv[i] << ((i-38)*8))

        fixdelaytxs = 0
        for i in range(42,45):
            fixdelaytxs += (recv[i] << ((i-42)*8))

        fixdelayrxm = 0
        for i in range(46,49):
            fixdelayrxm += (recv[i] << ((i-46)*8))

        fixdelayrxs = 0
        for i in range(50,53):
            fixdelayrxs += (recv[i] << ((i-50)*8))

        skew = 0
        for i in range(54,57):
            skew += (recv[i] << ((i-54)*8))
        
        offset = 0
        for i in range(58,61):
            offset += (recv[i] << ((i-58)*8))

        updatecnt = 0
        for i in range(62,65):
            updatecnt += (recv[i] << ((i-62)*8))
    else:
        print("unsupport command response")
        return

def main():
    serial_recv = SerialTx(uart_port,cmd_tx)
    if(len(serial_recv)>0):
        cmd_decode(serial_recv)
    else:
        print("recv nothing")

def SerialTx(device,cmd):
    ser_device="/dev/ttyUSB"+str(device)
    ser = serial.Serial(ser_device,115200,timeout=0.5)
    if ser.isOpen():
        for mes in cmd:
            ser.write(chr(mes).encode("utf-8"))
            time.sleep(0.05)
        time.sleep(0.5)
        if ser.in_waiting:
            return(ser.read(ser.in_waiting))
        else:
            return []
    else:
        print("Serial Open Error")
        return []

if __name__ == '__main__':
    # while True:
    main()
        # time.sleep(1)

# // 0        0x7B
# // 1        0x7B 
# // 2        0x03
# // 3 - 10   second counter
# // 11- 14   nanosecond counter
# // 15- 16   temperature, centigrade
# 
# // 17       port 0, link status, 0: link down, 1 link up
# // 18       port 0, lock status, 0: unlocked, 1: locked
# // 19       port 0, ptpmode,     0: UNKNOWN, 1: GM, 2: MASTER, 3: SLAVE
# // 20       port 0, ptp state   
		                # // 0: none,		1: PPS_INITIALIZING,2: PPS_FAULTY,
		                # // 3: PPS_DISABLED,4: PPS_LISTENING,	5: PPS_PRE_MASTER,
		                # // 6: PPS_MASTER, 	7: PPS_PASSIVE,		8: PPS_UNCALIBRATED,
		                # // 9: PPS_SLAVE,	100: WRS_PRESENT,	101: WRS_S_LOCK,
		                # // 102: WRS_M_LOCK,103: WRS_LOCKED,	104, 108-116:WRS_CALIBRATION,
		                # // 105: WRS_CALIBRATED, 106: WRS_RESP_CALIB_REQ, 107: WRS_WR_LINK_ON,
# // 21       port 0, servo_state
                        # //	0: WR_UNINITIALIZED,	1: WR_SYNC_NSEC,	2: WR_SYNC_TAI,
		                # // 	3: WR_SYNC_PHASE,		4: WR_TRACK_PHASE,	5: WR_WAIT_OFFSET_STABLE,
# // 22-29    port 0, round trip delay, ps
# // 30-37    port 0, master to slave delay, ps
# // 38-41    port 0, fixed delay txm, ps
# // 42-45    port 0, fixed delay txs, ps
# // 46-49    port 0, fixed delay rxm, ps
# // 50-53    port 0, fixed delay rxs, ps
# // 54-57    port 0, skew(delayms - prev_delayms), ps
# // 58-61    port 0, calculated clock offset, ps
# // 62-65    port 0, servo update count
# 
# // 66       port 1, link status, 0: link down, 1 link up
# // 67       port 1, lock status, 0: unlocked, 1: locked
# // 68       port 1, ptpmode,     0: UNKNOWN, 1: GM, 2: MASTER, 3: SLAVE
# // 69       port 1, ptp state   
		                # // 0: none,		1: PPS_INITIALIZING,2: PPS_FAULTY,
		                # // 3: PPS_DISABLED,4: PPS_LISTENING,	5: PPS_PRE_MASTER,
		                # // 6: PPS_MASTER, 	7: PPS_PASSIVE,		8: PPS_UNCALIBRATED,
		                # // 9: PPS_SLAVE,	100: WRS_PRESENT,	101: WRS_S_LOCK,
		                # // 102: WRS_M_LOCK,103: WRS_LOCKED,	104, 108-116:WRS_CALIBRATION,
		                # // 105: WRS_CALIBRATED, 106: WRS_RESP_CALIB_REQ, 107: WRS_WR_LINK_ON,
# // 70       port 1, servo_state
                        # //	0: WR_UNINITIALIZED,	1: WR_SYNC_NSEC,	2: WR_SYNC_TAI,
		                # // 	3: WR_SYNC_PHASE,		4: WR_TRACK_PHASE,	5: WR_WAIT_OFFSET_STABLE,
# // 71-78    port 1, round trip delay, ps
# // 79-86    port 1, master to slave delay, ps
# // 87-90    port 1, fixed delay txm, ps
# // 91-94    port 1, fixed delay txs, ps
# // 95-98    port 1, fixed delay rxm, ps
# // 99-102   port 1, fixed delay rxs, ps
# // 103-106  port 1, skew(delayms - prev_delayms), ps
# // 107-110  port 1, calculated clock offset, ps
# // 111-114  port 1, servo update count
# 
# // 115      0x7D
# // 116      0x7D
