#!/bin/bash
# 
# Title:		NMap Dump
# Description:	Dumps NMap scan data to USB storage.
# Author: 		infoskirmish.com
# Version:		1.0
# Category:		sniffing
# Target: 		Any
# Net Mode:		NAT

# LEDs
# SUCCESS:		Scan complete
# FAIL:			No USB storage found
# SCANNING:		Rapid White

#### Constants ####

rndDecoyNumber=5					                    # Number of decoy IPs to spawn
spoofDevType="Cisco"				                    # Spoof the MAC of this device type
interface="eth0"					                    # Interface to scan
netSleep=10						                        # Seconds to sleep while loading NAT

lootPath="/mnt/loot/nmapdump"		                    # Path to store results
lootFileNameScheme="nmapdump_$(date +%Y-%m-%d-%H%M)"	# File name scheme 

#### Payload Code ####

function finish() {

	# Sync filesystem
	sync

	# Indicate successful shutdown
	LED B SUCCESS
	sleep 1

	# Halt the system
	LED OFF
	halt

}

function run() {

	# Create loot directory
	mkdir -p $lootPath &> /dev/null

	# Get IP subnet
	LANSubNet=$(ip -o -f inet addr show | awk '/scope global/ {print $4}')

	# Log subnet to IP address
	echo $LANSubNet >> $lootPath/log.txt
	
	# Set networking to NAT and sleep to allow time to sync up.
	NETMODE NAT
	sleep ${netSleep}

	# Starting scanning LED (rapid white blink)
  	LED W FAST

	# Run nmap scan with options
	nmap -Pn -e $interface -sS -F -sV -oA $lootPath/$lootFileNameScheme -D RND:$rndDecoyNumber --randomize-hosts --spoof-mac $spoofDevType $LANSubNet >> $lootPath/log.txt

	# Done scanning; clean up.
	finish
}


# Check if we have USB storage
if [ -d "/mnt/loot" ]; then
	
	# Show attack LED
	LED ATTACK

	# ATTACK!!!!
	run

else

	# USB storage could not be found; log it in ~/payload/switch1/log.txt
	echo "Could not load USB storage. Stopping..." > log.txt

	# Display FAIL LED 
	LED FAIL

fi
