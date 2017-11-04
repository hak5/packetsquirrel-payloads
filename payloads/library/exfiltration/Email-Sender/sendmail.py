import sys
sys.path.append("/root/extensions")
from sendemail.py import send_mail

send_mail('im-just-a-squirrel@giving-you-my-nuts.net', 'EmailTo@SendTo.net',
                   'You Got My Nuts',
                   'Enjoy this package',
                   files=["/Path/To/My/Nuts.txt"],
                   server='MAIL.SERVER.com', username='USERNAME', password='PASSWORD')
