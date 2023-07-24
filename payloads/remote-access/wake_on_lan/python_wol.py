#!/usr/bin/python

import sys
import socket

# Simplified function to send a wake-on-lan packet
def send_wol(destination):
    sync = "FF" * 6
    macs = destination * 16
    payload = bytes.fromhex(sync + macs)
    
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
    sock.sendto(payload, ("255.255.255.255", 9))

# Send a WoL packet for each MAC address we
# were called with
for mac in sys.argv[1:]:
    fin_mac = mac.replace(":", "")
    send_wol(fin_mac)

