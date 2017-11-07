#!/bin/bash
# 
# Title:		NMap Dump
# Description:		Dumps NMap scan data to USB storage.
# Author: 		infoskirmish.com
# Version:		1.0
# Category:		sniffing
# Target: 		Any
# Net Mode:		TRANSPARENT

# LEDs
# SUCCESS:		Scan complete
# FAIL:			No USB storage found
# SCANNING:		Rapid White

#### Constants ####

defaultInterface="lo"					# If you know which interface will allow outbound traffic you can specify it here
							# leaving it blank will enable the payload trying to attempt to figure out which
							# interface to use.

rndDecoyNumber=5					# Number of decoy IPs to spawn
spoofDevType="Cisco"					# Spoof the MAC of this device type

netSleep=10						# Seconds to sleep while loading NAT
mode="TRANSPARENT"					# Squirrel NETMOD TRANSPARENT | BRDIGE | NAT | VPN | NONE (this won't kick you off ssh session)
onEnd="halt"						# When done what should we do? reboot | halt | nothing | poweroff

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
	
	# Set networking mode to user preferance and sleep to allow time to sync up.
	# If set to NONE this will not be set and thus not kick you out of your SSH session.
	if [ "$mode" != "NONE" ]; then
	
		NETMODE $mode
		sleep $netSleep

	fi 

	# Log ifconfig data; helpful for troubleshooting 
	ifconfig >> $lootPath/log.txt

	# Starting scanning LED (rapid white blink)
  	LED W VERYFAST

	# Run nmap scan with options

	# Now lets figure out which interface to use.
	iface=$(ip -o link show | awk '{print $2}')

	# Set ipv6 default to null
	ipv6=""

	# Now lets look at the ip addresses assigned to the various interfaces.
	while IFS= read -r line; do

		# Standardize interface name
        	line="${line//:}"

		# We can skip lo
        	if [ "$line" != "lo" ]; then

			# Get IP Address for Interface.
			ifip=$(ifconfig $line 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://')

			# Make sure result is not null.
			if [ "$ifip" ]; then

				# Store for later use the ip addresses associted with interface.
				# We don't want an empty 1st line.
				if [ "$ipaddresses" ]; then
					ipaddresses+=$'\n'$ifip
				else
					ipaddresses=$ifip
				fi
			
				# If user has specified a default interface than we can disregard.
				if [ ! "$defaultInterface" ]; then

					# Store the interface for later use.	
					# We don't want an empty 1st line.
					if [ "$interfaces" ]; then
						interfaces+=$'\n'$line
					else
						interfaces=$line
					fi
				fi
			
				# convert ip to subnet
				newSubNet=`echo $ifip | cut -d"." -f1-3`
				newSubNet=$newSubNet".1/24"
		
				# Add subnet to list
				# We don't want a leading empty character.
				if [ "$newSubNet" ]; then
					targets+=" $newSubNet"
				else
					targets=$newSubNet
				fi

			fi	

	        fi # end our test for lo

	done <<< "$iface"  # loop to gather IP addresses

	# Clean up subnets to remove accidental double spaces.
	echo "$targets" | awk '$1=$1' &> /dev/null

	# if targets is empty we have no subnets. Let's check if we can find IPv6 
	if [ ! "$targets" ]; then

		# Collect all uniqu IPv6 address that we can ping.
		ipv6=$(ping -6 ff02::1 -w 10 2>/dev/null | awk '/from/ {print $4}' | cut -d":" -f1-6 | sort | uniq | tr "\r\n" " ")
		if [ ! "$ipv6" ]; then

			# We could not find any ipv4 address and ipv6 returned nothing.
			echo "Could not accquire any IP addresses to scan." >> $lootPath/log.txt
			sync
			LED OFF
			exit 1
		fi
	fi

	# Add lo as some setups the loopback maybe the interface to send out traffic
	# If user supplies default interface tie in their selection and disregard the
	# auto locate data.
	if [ ! "$defaultInterface" ]; then
		interfaces+=$'\nlo'
	else
		interfaces=$defaultInterface
	fi

	# log subnets and ip addresses we found
	echo "Subnets to scan $targets" >> $lootPath/log.txt
	echo "IPs to scan $ipaddresses" >> $lootPath/log.txt

	# Document the fact we will be scanning ipv6
	if [ "$ipv6" ]; then
		echo "We will be scanning ipv6 addresses" >> $lootPath/log.txt
	fi

	# Now lets find the interface that will allow outbound traffic on the LAN.
	while IFS= read -r interface; do

		# We will use the ip addresses we found to see if this interface can ping it.
		while IFS= read -r ip; do

			# If we can send ping packets then the interface is likley able to work with nmap
			# Determin if we should ping in ipv4 or ipv6
			if [ ! "$ipv6" ]; then

				if [[ ! $(ping -I $interface $ip -w 3 | grep '0 packets received') ]]; then
			
					# Make sure wee don't end up with a blank first line.
					if [ "$goodInterface" ]; then

						goodInterfaces+=$'\n'$interface
					else
						goodInterfaces=$interface
					fi			
				fi

			else

				if [[ ! $(ping -6 ff02::1 -w 3 | grep '0 packets received') ]]; then
			
					# Make sure wee don't end up with a blank first line.
					if [ "$goodInterface" ]; then

						goodInterfaces+=$'\n'$interface
					else
						goodInterfaces=$interface
					fi			
				fi

			fi

		done <<< "$ipaddresses" # end loop to find interfaces we can use

	done <<< "$interfaces" # end loop to scan interfaces

	# Log interfaces we can use
	echo "Interfaces allowing outbound traffic: $goodInterfaces" >> $lootPath/log.txt

	# Make sure we have interfaces that will allow outbound traffic.	
	if [ "$goodInterfaces" ]; then	
		while IFS= read -r goodInterface; do

			# Finally! Lets run NMap!
			# Use ipv4
			if [ ! "$ipv6" ]; then
				nmap -Pn -e $goodInterface -sS -F -sV -oA $lootPath/$lootFileNameScheme -D RND:$rndDecoyNumber --randomize-hosts --spoof-mac $spoofDevType $targets >> $lootPath/log.txt
			else
				# Use ipv6
				nmap -Pn -e $goodInterface -sT -F -R -oA $lootPath/$lootFileNameScheme --randomize-hosts --spoof-mac $spoofDevType -6 $ipv6 >> $lootPath/log.txt
			fi
	
		done <<< "$goodInterfaces"

	else
		echo "Could not find any interfaces that will allow outbound traffic." >> $lootPath/log.txt
		exit 1
	fi


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
