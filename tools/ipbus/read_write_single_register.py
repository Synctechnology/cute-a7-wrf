#!/bin/env python

import random # For randint
import sys # For sys.argv and sys.exit
import uhal

if __name__ == '__main__':

    # PART 1: Argument parsing
    # if len(sys.argv) != 4:
        # print "Incorrect usage!"
        # print "usage: read_write_single_register.py <path_to_connection_file> <connection_id> <register_name>"
        # sys.exit(1)

    # connectionFilePath = sys.argv[1];
    connectionFilePath = "../ipbus/connections.xml"
    # deviceId = sys.argv[2];
    deviceId = "device1"
    # registerName = sys.argv[3];
    registerName = "sysmon.temp"
    #registerName = "axi_readback_reg.word0"


    # PART 2: Creating the HwInterface
    connectionMgr = uhal.ConnectionManager("file://" + connectionFilePath);
    hw = connectionMgr.getDevice(deviceId);
    node = hw.getNode(registerName)


    # PART 3: Reading from the register
    print("Reading from register '" + registerName + "' ...")
    reg = node.read();
    # dispatch method sends read request to hardware, and waits for result to return
    # N.B. Before dispatch, reg.valid() == false, and reg.value() will throw
    hw.dispatch();

    print("... success!")
    print("Value =", hex(reg))


    # PART 4: Writing (random value) to the register
    # print "Writing random value to register '" + registerName + "' ..."
    # node.write(random.randint(0, 0xffffffff));
    # # N.B. Depending on how many transactions are already queued, this write request may either be sent to the board during the write method, or when the dispatch method is called
    # hw.dispatch();
    # # In case there are any problems with the transaction, an exception will be thrown from the dispatch method
    # # Alternatively, if you want to check whether an individual write succeeded or failed, you can call the 'valid()' method of the uhal::ValHeader object that is returned by the write method
    # print "... success!"

