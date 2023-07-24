import socket
import struct
import os
import sys
from subprocess import Popen, PIPE
import fcntl

#### OPTIONS
interface = str(sys.argv[1])
SINGLETARGET = int(sys.argv[2])
       ##########  if SINGLETARGET is 1  WAKETARGET is used
WAKETARGET = str(sys.argv[3])
       ########## if SINGLETARGET is 0  ranges are used
startrange = int(sys.argv[4])
endrange = int(sys.argv[5])
####

def wake_on_lan(host, broad):
    if host == '00:00:00:00:00:00':
      return False
    try:
      macaddress = host
    except:
      return False
    if len(macaddress) == 12:
        pass
    elif len(macaddress) == 12 + 5:
        sep = macaddress[2]
        macaddress = macaddress.replace(sep, '')
    else:
        raise ValueError('Incorrect MAC address format')
    data = ''.join(['FFFFFFFFFFFF', macaddress * 20])
    send_data = b''
    for i in range(0, len(data), 2):
        send_data = b''.join([send_data,
                             struct.pack('B', int(data[i: i + 2], 16))])
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
    sock.sendto(send_data, (broad,9))
    print('sent to '+host)
    return True

def get_mac(IP):
    try:
        Popen(["ping", "-c1", IP], stdout = PIPE)
        pid = Popen(["cat", "/proc/net/arp"], stdout = PIPE )
        mac = str(pid.communicate()[0]).split()
        mac = mac[int(mac.index(IP)+3)]
    except:
        pass
    return mac

def get_ip_address(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915,
        struct.pack('256s', ifname)
    )[20:24])

ip = str(get_ip_address(interface))
submask = socket.inet_ntoa(struct.pack(">L", (1<<32) - (1<<32>>24)))
addr = ip.split('.')
cidr = int(sum([bin(int(x)).count('1') for x in submask.split('.')]))
mask = submask.split('.')
net = []
for i in range(4):
        net.append(int(addr[i]) & int(mask[i]))
for i in range(int(32 - cidr)):
        net[3 - i/8] = net[3 - i/8] + (1 << (i % 8))

if SINGLETARGET == 0:
    ip = ip.split('.')
    exclude = str(ip[3])
    del ip[3]
    ip.append('x')
    ip = ".".join(map(str, ip))
    for num in range(startrange, endrange):
        if str(num) != exclude:
            wakeip = ip.replace('x', str(num))
            try:
                wake_on_lan(get_mac(str(wakeip)), str(".".join(map(str, net))))
            except:
                pass
else:
    try:
        wake_on_lan(get_mac(str(WAKETARGET)), str(".".join(map(str, net))))
    except:
        pass
