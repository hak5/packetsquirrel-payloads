# Meterpreter-via-SSH

## Overview
This payload starts Packet Squirrel in NAT mode and awaits for user input. When the button is pressed, the payload connects to a remote SSH server and creates a local port tunnel. It then launches a meterpreter shell over said tunnel.

The intent is to get a meterpreter shell on a target network in a way that hides meterpreter network traffic behind legitimate SSH activity.

## Operational Design Considerations
* Payload remains silent on the network until user presses the button.
* Payload stops the SSH connection if meterpreter shell fails.
* Payload always keeps only 1 copy of SSH+meterpreter processes running (even if the button is pressed many times).

## Getting Started
Copy the payload to Packet Squirrel into desired switch folder, then edit the script to configure your server options:
* SSH_USER - username on remote SSH server
* SSH_HOST - ip/domain of remote SSH server

In case you choose to change the default meterpreter port, don't forget to change it on the metasploit side as well.
* MSF_PORT - port of meterpreter listener

### Generate SSH Key on Squirrel
You will likely have to generate an ssh key-pair (use default location and empty password) on your Packet Squirrel:
```
root@squirrel:~# ssh-keygen
```
### Allow Squirrel on SSH Server
Then you will need to copy the contents of /root/.ssh/id_rsa.pub from Packet Squirrel to the SSH server authorized file:
```
user@server:~# mkdir ~/.ssh
user@server:~# echo 'paste id_rsa.pub contents inside this quote' > ~/.ssh/authorized_keys
```
### Run Metasploit with Resource 
```
msf@server:~# msfconsole -r server.rc
```

## LED Definitions
1. Configure NETMODE 
* Solid Magenta
2. Connect to SSH Server
* SUCCESS - Blink Amber 5 Times
* FAIL - Blink Red 2 Times
3. Launch meterpreter
* SUCCESS - Blink Cyan 1 Time
* FAIL - Blink Red 1 Time

## Hardening Recommendations
1. Use an account with limited privileges for SSH access on the server.
2. Use a dedicated account for Packet Squirrel device (audit usage with SSH access logs).
3. Disable PasswordAuthentication in sshd_config on the server.
