#!/bin/bash
#
# Title:        OpenVPN
# Description:  Create a VPN connection to an OpenVPN server. Optionally, send
#               traffic from the clients through said tunnel.
# Author:       Hak5
# Version:      1.1
# Category:     remote-access
# Target:       Any
# Net Mode:     BRIDGE, VPN

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

	# Set NETMODE to BRIDGE and wait 3 seconds to ensure that things can settle
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

	# Cycle between VPN configs when the button is pressed. The default
	# "config.ovpn" will be loaded on startup, and pressing the button will
	# cycle through all numbered VPN configs. To use this, add additional VPN
	# configs named "config1.ovpn", "config2.ovpn", etc.
	#
	# If no numbered configs exist, the button functions as a way to reset the
	# VPN connection.
	next=1
	while true; do
		NO_LED=true BUTTON

		# Stop openvpn and update the LED
		LED SETUP
		/etc/init.d/openvpn stop

		# Determine which config to load next
		if [ -f "${DIR}/config${next}.ovpn" ]; then
			uci set openvpn.vpn.config="${DIR}/config${next}.ovpn"
			uci commit
			next=$(($next + 1))
		elif [ -f "${DIR}/config1.ovpn" ]; then
			uci set openvpn.vpn.config="${DIR}/config1.ovpn"
			uci commit
			next=1
		fi

		# Start openvpn and update the LED
		/etc/init.d/openvpn start
		LED ATTACK
	done
}

# Start the payload
start &
