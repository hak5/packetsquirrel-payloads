#!/bin/bash
# 
# Title:		Togglable-VPN
# Description:	Based on the default VPN payload; this can now create a VPN-connection to an OpenVPN-server, 
#				or if the button is pressed, send traffic from the clients through said tunnel.
#				This way no editing of the payload is required to switch modes. 
#				On boot the Squirrel will wait for a button press for 10 seconds, if it is pressed, the VPN will 
#				launch in client mode, if it is not pressed in the interval it will launch in remote-access mode.
# Author: 		DannyK999
# Credit:		Credit to Hak5 for original VPN payload.
# Version:		1.0
# Category: 	remote-access
# Target: 		Any
# Net Mode:		BRIDGE, VPN

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

	# Check for button press to see whether to set NETMODE to BRIDGE or VPN 
	# and wait 3 seconds to ensure that things can settle

	BUTTON 10s && {
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
