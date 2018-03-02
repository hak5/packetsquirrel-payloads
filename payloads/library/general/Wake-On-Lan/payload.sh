#!/bin/bash 
LED STAGE1
NETMODE NAT

#### OPTIONS
INT='eth0'                #interface of the outgoing interface
SIN='0'                   # single target or range ( 1 or 0 )
TAR='192.168.1.2'         # single target 
SRAN='1'                  # ip range start
ERAN='255'                # ip range end
####

function failedpy() {
    LED FAIL
    exit
}

LED ATTACK
python /root/payloads/$(SWITCH)/wol.py $INT $SIN $TAR $SRAN $ERAN || failedpy
LED FINISH
