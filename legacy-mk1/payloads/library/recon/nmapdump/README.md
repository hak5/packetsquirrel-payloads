Title:	     	NMap Dump

Description:	Dumps NMap scan data to USB storage.

Author: 		infoskirmish.com

Version:		1.0

Category:		sniffing

Target: 		Any

Net Mode:		NAT


LEDs

SUCCESS:		Scan complete

FAIL:			No USB storage found

SCANNING:		Rapid White

This payload will launch NMap on a given interface (default eth0) and scan the local subnet. There is no need to know the subnet as the payload will capture and infer the subnet from the IP it receives while launching. 

The payload will store scan files in all three file types supported by nmap. Also the payload will create a log.txt file to dump process information which may be useful to troubleshoot errors. The default path is /mnt/loot/nmapdump

The payload has common variables that maybe changed located at the top of the file making customizing this payload as your deployment needs dictate. 
