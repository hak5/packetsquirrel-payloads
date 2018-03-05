#!/bin/bash 
LED STAGE1
NETMODE NAT

#### OPTIONS
INTERFACE='eth0'                #interface of the outgoing interface
SINGLE='0'                   # single target or range ( 1 or 0 )
TARGET='192.168.1.2'         # single target 
STARTRANGE='1'                  # ip range start
ENDRANGE='255'                # ip range end
####

function failedpy() {
    LED FAIL
    exit
}

LED ATTACK
python /root/payloads/$(SWITCH)/wol.py $INTERFACE $SINGLE $TARGET $STARTRANGE $ENDRANGE || failedpy
LED FINISH
