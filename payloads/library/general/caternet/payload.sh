# Title: Caternet
# Author: Hak5Darren
# Version: 1.0
# Description: Forwards all traffic to local webserver hosting cat photos.
# Props: In loving memory of Hak5Kerby

LED SETUP
NETMODE NAT
echo "address=/#/172.16.32.1" > /tmp/dnsmasq.address
/etc/init.d/dnsmasq restart

LED ATTACK
iptables -A PREROUTING -t nat -i eth0 -p udp --dport 53 -j REDIRECT --to-port 53
python -m SimpleHTTPServer 80
