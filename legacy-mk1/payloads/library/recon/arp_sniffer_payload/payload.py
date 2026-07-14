#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Author: Julio Della Flora
Title: arp_sniffer_payload
Description: 
    This payload captures ARP packets to identify devices on the local network.
    It logs each unique source MAC and IP address pair to a file.

Target: 
    Local network interfaces capable of capturing ARP packets.

Dependencies:
    - Python 2.7 or 3.x
    - Access to network interface in promiscuous mode.

Configurable Options:
    LOG_FILE_NAME = 'arp_sniffer.log'  # Name of the log file
    INTERFACE = 'eth0'                # Interface to sniff on
"""

import socket
import struct
import logging

# Configurable variables
LOG_FILE_NAME = 'arp_sniffer.log'
INTERFACE = 'eth0'

def mac_addr(mac_string):
    """Convert a MAC address string into a readable format."""
    return ':'.join('%02x' % (ord(b)) for b in mac_string)

def ipv4_addr(addr):
    """Convert an IPv4 address string into a readable format."""
    return '.'.join(map(str, struct.unpack('!BBBB', addr)))

def sniff():
    # Setup logging
    logging.basicConfig(filename=LOG_FILE_NAME, level=logging.INFO, format='%(asctime)s %(message)s')

    # Create a raw socket to capture ARP packets
    s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.ntohs(0x0003))

    # Set to store seen MAC and IP address pairs
    seen_addresses = set()

    while True:
        # Receive packet
        raw_data, addr = s.recvfrom(65535)
        # Unpack ethernet frame
        dest_mac, src_mac, eth_proto = struct.unpack('! 6s 6s H', raw_data[:14])

        # Check for ARP packet
        if eth_proto == 0x0806:
            # Unpack ARP packet
            arp_header = raw_data[14:42]
            arp_data = struct.unpack('! H H 1s 1s 2s 6s 4s 6s 4s', arp_header)
            
            # Check if ARP packet is request or reply
            if arp_data[4] == b'\x00\x01' or arp_data[4] == b'\x00\x02':
                src_mac_str = mac_addr(src_mac)
                src_ip_str = ipv4_addr(arp_data[6])

                # Check for new address pair
                if (src_mac_str, src_ip_str) not in seen_addresses:
                    seen_addresses.add((src_mac_str, src_ip_str))
                    log_message = "Source MAC: {}, Source IP: {}".format(src_mac_str, src_ip_str)
                    print(log_message)
                    logging.info(log_message)

# Start sniffing
sniff()
