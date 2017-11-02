#!/bin/bash
# 
# Title:		NMap Dump
# Description:		Dumps NMap scan data to USB storage.
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

rndDecoyNumber=5					# Number of decoy IPs to spawn
spoofDevType="Cisco"					# Spoof the MAC of this device type

toLan="eth1"						# Interface out to lan
toTarget="eth0"						# Interface to target
netSleep=10						# Seconds to sleep while loading NAT
mode="TRANSPARENT"					# Squirrel NETMOD
onEnd="nothing"						# When done what should we do? reboot | shutdown | nothing | poweroff

scanTargetSubNet=true					# Attempt to get subnet of target then scan it. true | false
scanGatewaySubNet=true					# Attempt to get gateway ip and then scan it. true | false

lootPath="/mnt/loot/nmapdump"				# Path to store results
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

	case "$onEnd" in
		"poweroff") poweroff ;;
		"reboot") reboot ;;
		"halt") halt ;;
		"nothing") echo "see ya!" >> $lootPath/log.txt ;;
		*) reboot;;
	esac

}

function run() {

	# Create loot directory
	mkdir -p $lootPath &> /dev/null

	# Get IP subnet
	if [ "$scanTargetSubNet" == "true" ]; then
		
		rawip=$(ifconfig $toLan 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://')	
		LANip=`echo $rawip | cut -d"." -f1-3`
		LANSubNet=$LANip".1/24"
	
		# Log subnet to IP address
		echo "Target subnet:$LANSubNet" >> $lootPath/log.txt
	fi

	# Get gateway subnet
	if [ "$scanGatewaySubnet" == "true" ]; then

		rawip=$(ifconfig $toTarget 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://')	
		gatewayIP=`echo $rawip | cut -d"." -f1-3`
		gatewaySubnet=$gatewayIP".1/24"

		# Log Gateway subnet
		echo "Gateway subnet $gatewaySubnet" >> $lootPath/log.txt
	fi

	# Make sure we have at least something to scan.
	if [ ! "$LANSubNet" ] && [ ! "$gatewaySubnet" ]; then
		
		echo "Could not accquire any IP addresses to scan." >> $lootPath/log.txt
		exit 1

	fi

	# Concat ips, clean up and log output.
	targets="$LANSubNet $gatewaySubnet"
	echo "$targets" | awk '$1=$1' &> /dev/null
	echo "IPs to scan $targets" >> $lootPath/log.txt
	
	# Set networking to NAT and sleep to allow time to sync up.
	NETMODE $mode
	sleep $netSleep

	# Log ifconfig data; helpful for troubleshooting 
	ifconfig >> $lootPath/log.txt

	# Starting scanning LED (rapid white blink)
  	LED W FAST

	# Run nmap scan with options

	# Now lets figure out which interface to use.
	iface=$(ip -o link show | awk '{print $2}')

	# Got interfaces lets check them out.
	echo "$iface" | while IFS= read -r line; do

		# Standardize interface name
        	line="${line//:}"

		# We can skip lo
        	if [ "$line" != "lo" ]; then

			# For good measure let's see if this interface contains a new ip address as so far we have only checked eth0 and eth1
			ifip=$(ifconfig $line 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://')

			# convert to subnet
			newSubNet=`echo $ifip | cut -d"." -f1-3`
			newSubNet=$newSubNet".1/24"

			# Let's not waste time if we already have collected this IP address
			if [[ ! $(echo "$targets" | grep "$newSubNet") ]]; then

				# It's a new subnet! Add it to list
				targets="$targets $newSubNet"

				# clean up list 
				echo "$targets" | awk '$1=$1' &> /dev/null

				# Log our new subnet
				echo "More ips to scan $targets" >> $lootPath/log.txt
			fi			
	
			# Now let's test if this interface allows outbound traffic
			if [[ ! $(ping -I $line 8.8.8.8 -w 3 | grep '0 packets received') ]]; then
			
				# Yes! This interface allows outbound traffic; lets run NMap!
				nmap -Pn -e $line -sS -F -sV -oA $lootPath/$lootFileNameScheme -D RND:$rndDecoyNumber --randomize-hosts --spoof-mac $spoofDevType $targets >> $lootPath/log.txt
			else
				# Nope no outbound allowed. Log it for possible debugging.
				echo "$line is unable to send data; skipping.." >> $lootPath/log.txt
			fi

	        fi # end our test for lo

	done # loop to the next interface in our list
	
	# Done scanning; clean up.
	finish

} # end run() function


# Check if we have USB storage
if [ -d "/mnt/loot" ]; then

	# Clear log file
	echo "" > $lootPath/log.txt	

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
