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
   python /root/payloads/$SWITCH_POS/sendmail.py $FROM $RCPT "$SUBJECT" "$BODY" $SERVER $USER $PASS
   LED FINISH
}

NETMODE NAT
run
