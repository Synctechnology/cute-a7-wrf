#!/usr/bin/env python3
import os,sys
import serial
import time
def main():
    Serial_recv = SerialTx(0,"temp")
    print(Serial_recv)

def SerialTx(device,cmd):
    ser_device="/dev/ttyUSB"+str(device)
    ser = serial.Serial(ser_device,115200,timeout=0.5)
    if ser.isOpen():
        mes = cmd+"\r"
        i = 0
        while mes[i]!="\r":
            ser.write(mes[i].encode('utf-8'))
            time.sleep(0.05)
            i+=1
        ser.write("\r".encode('utf-8'))
        return(ser.read(1200).decode('utf-8'))
    else:
        print("Serial Open Error")
        return("null") 

if __name__ == '__main__':
    main()
