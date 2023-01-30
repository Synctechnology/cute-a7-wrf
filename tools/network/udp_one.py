# -*- coding: utf-8 -*-
import sys
import socket
import struct
import string
import time
import binascii

#####################
##    UDP  Info   ###
#####################
MY_IP = "192.168.2.1"
UDP_IP= "192.168.2.3"
UDP_TX_PORT = 60000
UDP_RX_PORT = 60002 
#MESSAGE = "Hello, World!"
MESSAGE = "abc"

#####################
##    TDC  Para   ###
#####################
TimeStampLen = 8 ## the length of Timestamp, 4n bits

sock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
sock.bind((MY_IP,UDP_RX_PORT))

sock.sendto(MESSAGE,(UDP_IP,UDP_TX_PORT))
while True:
   # recv_data, addr = sock.recvfrom(1024)
    sock.sendto(MESSAGE,(UDP_IP,UDP_TX_PORT))
    time.sleep(0.01)
   # print(recv_data)
#    data_hex = binascii.hexlify(recv_data)
#    data_len = len(data_hex) / TimeStampLen
#    data = []
#    print(data_len)
#    for i in range(0,data_len):
#        data.append(int(data_hex[8*i:8*i+8],16))
#     
#  time.sleep(0.05)

sock.close()

