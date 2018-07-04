#!/bin/bash
# Title:		Uptime
# Description:		The uptime payload displays the current time, the length of time the system has been up, the number of users, and the load average of the system over the last 1, 5, and 15 minutes.
# Author:		Moliata
# Version:		1.0
# Category:		general
# Target:		Packet Squirrel by Hak5
# Net Mode:		TRANSPARENT
function start()
{
        LED SETUP
        NETMODE TRANSPARENT
        mkdir -p /mnt/loot/uptime
        sleep 5
}
function run() {
        LED ATTACK
        while true
                do
                        BUTTON && {
                                uptime >> /mnt/loot/uptime/uptime.log
                                LED FINISH
                        }
        done
}
[[ ! -f /mnt/NO_MOUNT ]] && {
        start && run
} || {
	LED FAIL
}
