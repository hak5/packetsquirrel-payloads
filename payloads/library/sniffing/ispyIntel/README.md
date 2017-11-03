|                 |                                                                                                    |
|:----------------|:---------------------------------------------------------------------------------------------------|
| **Title**	  | iSpy Passive Intel Gathering								       |
| **Description** | Launches various tools to sniff out intel data. Payload will run until the button is pressed.      |
| **Author**	  | [infoskirmish.com](http://www.infoskirmish.com)                                                   |
| **Version**	  | 1.0												      |
| **Category**	  | sniffing											      |
| **Target** 	  | Any												      |
| **Net Mode**	  | Any (you choose)										      |

| Meaning   | Color             | Description                 |
|:----------|:-----------------:|:----------------------------|
| SUCCESS:  | Blink Green       | Payload ended complete      |
| CLEAN UP: | Rapid White       | Payload is shutting down    |
| FAIL:     | Blink Red         | No USB storage found        |
| ATTACK:   | Blink Yellow      | Payload is loging traffic   |

This payload will automate gathering various recon data on whatever passes between it's Ethernet ports. Since all the data log file names are marked with a unique date stamp you can freely move from target to target deploy, gather, collect, move on without fear you are overwriting previous logs. 

### **Requirements**
+ USB access to store loot.

### **Setup**

1. Edit the config variables at the top.

     The main variables are:

          lootPath="/mnt/loot/intel"  # Path to loot
          mode="TRANSPARENT"          # Network mode we want to use
          interface="br-lan"          # Interface to listen on

2) Copy payload.sh into the ~/payloads/switch<n> folder you wish to deploy on.

3) Connect into a target machine with access to the LAN.

4) Set switch to the <n> spot and power up.

5) Leave, get coffee, take a nap while everything is recorded and parsed for future use.

6) When done; hit the button. The LED will rapidly flash white to let you know it is finishing up.

7) When all is done the LED will just go blank. It is now safe to unplug and go about your day.

### **Tasks that are started**
| Task     | About                                                                        |
|:---------|:-----------------------------------------------------------------------------|
|tcpdump   | So you have a record of every packet that was TX and RX                      |
|urlsnarf  | So you can see all websites that were visited                                |
|dsniff    | Will attempt to acquire passwords and what not                               |
|ngrep     | On ports 80 and 21 with the filter for common password fields                |
|ngrep     | On ports 80 and 21 with the filter for common session id fields              |
|log.txt   | Logs the progress of the payload for easy troubleshooting.                   |

### **Clean Up**
Once completed (aka when the button is pressed) the payload will automatically parse the TCPDump log file for the following items and store the results in separate files. Note the TCPDump raw pcap file is left unharmed and still freely available for your dissecting pleasure. 

As this process can take some time the LED will change to a rapid white blink letting you know the button command was recieved and the payload is in the process of shutting down.

+ ipv4found.txt   Will contain a unique list of all the ipv4 which the pcap file contains
+ maybeEmails.txt Is a very loose search for possible email addresses that came across the wire in plain text.
