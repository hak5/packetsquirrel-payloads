# Squirrel SSH Proxy Pivot
___
Have you ever laid down a Squirrel and thought 'darn I really want to pivot through this network, 
but I left all my leet tools on my other machine.'

Those days are over with this payload. Using a similar method to accessing the squirrel via SSH 
we can initiate a Dynamic Port Forwarding tunnel into the target network, just adding one more 
hop (bunnies should be good at this).

    Proxy Client     Remote SSH Host     Packet Squirrel        Proxy Target
          ___              ___             (inside LAN)              ___
         /  /|            /  /|             _______                 /  /|
        /__/ |  <=====>  /__/ |   <=====>  /______/`)   <=====>    /__/ |
        |--| |           |--| |           (__[__]_)/               |--| |
        | *|/            | *|/                                     | *|/


___
### Remote SSH Configuration
___

For this payload to function properly, the following must be configured

* SSH Key based Authentication
  * Remote SSH Host
  * Packet Squirel
* SSH Port forwarding
  * Both Hosts are required to support this

A separate SSH server is required for this payload to function. This server must be configured
to accept pubkey authentication for at least one user and contain the ssh key file on the Squirrel.
___
#### Remote SSH Server Pubkey Authentication
The configuration for the remote SSH server for pubkey authentication can be found here: https://gist.github.com/BlackPropaganda/3c50e1993014bd59905df77c2fd46869

Configuring the squirrel is similar. Just enroll the pubkey to /root/.ssh/authorized_keys. There's no need to modify the
SSHD config file since the config file does not persist between boots and pubkey authentication is enabled by default.
___
#### SSH Port Forwarding configuration on Remote SSH server

GatewayPorts and AllowTcpForwarding need to be enabled on the Remote SSH Server in order for the
proxy to function properly. More on this here https://gist.github.com/BlackPropaganda/2801c43a7754ac56b80e3d03ede29169

The Remote SSH Server will need a copy of the key generated for the Squirrel.

___
#### Squirrel SSH Pubkey Authentication

Lets create a new key for the Squirrel

    ssh-keygen -t rsa -b 1024 -f squirrel_rsa

In arming mode, run this:

    ssh-copy-id -i squirrel_rsa root@172.16.32.1

___
### Initiating the Proxy Connection
___

Copy the squirrel SSH key to the Remote SSH Server

    ssh -L 1080:localhost:1080 $user@$remote_server_ip "ssh -i /home/sshuser/squirrel_rsa -p $lport_fwd_port -D 1080 root@127.0.0.1"

Where:
* /home/sshuser/squirrel_rsa is the SSH key generated for the Squirrel, residing on the Remote SSH Server
* 1080 is the proxy port (socks5 default)
* $user is a user with TCP forwarding enabled on the Remote SSH Server
* $remote_server_ip is the Remote SSH Server IP
* $lport_fwd_port is the Squirrels ssh server reachable by the port configured in the Payload.

Goes without saying, but use at your own risk. Don't do bad things.