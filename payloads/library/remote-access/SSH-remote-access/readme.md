#Squirrel SSH Remote Access
____

### Concept:
The Packet Squirrel is a powerful tool for network implants. One operational issue with an implant of this nature
is that it cannot function beyond the pre-programmed payloads.

Using techniques like Dynamic Port Forwarding (SOCKS/SSH), this payload allows the user to create a Bastion 
inside a target network. This bastion allows the user to bypass less sophisticated firewall configurations, 
like so:

    Remote SSH Host         Target Behind Firewall
          ___                       ___
         /  /|                     /  /|
        /__/ |   <====[ X ]====>  /__/ |
        |--| |                    |--| |
        | *|/                     | *|/


    Remote SSH Host       Packet Squirrel      Target Behind Firewall
          ___               (inside LAN)            ___
         /  /|             _______                 /  /|
        /__/ |   <=====>  /______/`)   <=====>    /__/ |
        |--| |           (__[__]_)/               |--| |
        | *|/                                     | *|/
    
This assumes SSH is not denied by default on the targets' outbound firewall configuration. One limitation
is that this tool is susceptible to detection via NIDS. Multiple outbound connections and high-bandwidth 
utilization raises suspicion of potential attack, however this is only a concern for more sophisticated 
targets.

---

# SSH Server Configuration

---

A good background for this payload is this video that Darren made doing this on the Lan Turtle:
    https://www.youtube.com/watch?v=uIdvvrDrRj0


This payload requires an SSH server be operational somewhere on the internet. Typically, a password
is required to acquire shell access to these servers. This is a pain if you're trying to do everything
automatically, so openssh allows for cryptographic pubkey authentication. More on this here: 
https://www.redhat.com/sysadmin/key-based-authentication-ssh

Firstly, for security reasons you may want to create a user account specifically for this payload.
The reasoning is if the squirrel is lost or stolen someone has a key to your server, to mitigate this
threat, if the squirrel is lost in a contested environment, deleting the user will block access.

On most linux systems, the command is either 'useradd' or 'adduser', but this is distro specific.
After you create the user and are prompted with the new user password, bear in mind to save it because
you will need it during the pubkey installation process.

    useradd squirrel

Password-less authentication to a specific user account can be obtained by first enabling this in 
the openssh configuration file. This file is most commonly found in /etc/ssh/sshd_config and changing the line
'PubkeyAuthentication no' to 'PubkeyAuthentication yes'. Or, if your version does not have this,
you can append this line near the top of the configuration file under the authentication category, like so:

    # Authentication:

    #LoginGraceTime 2m
    #PermitRootLogin prohibit-password
    #StrictModes yes
    #MaxAuthTries 6
    #MaxSessions 10
    
    PubkeyAuthentication yes
    
    # Expect .ssh/authorized_keys2 to be disregarded by default in future.
    AuthorizedKeysFile      .ssh/authorized_keys .ssh/authorized_keys2
    
Also ensure that your AuthorizedKeysFile is present in your new users home directory.


Secondly, on an SSH client, you will need to generate the key. For the sake of demonstration,
we will use RSA 2048-bit keys, but you can use any of the following, such as dsa, ecdsa, ed25519 and rsa.

Keep in mind that the squirrel is a tiny computer and may have trouble with higher-bit symmetrical keys
like RSA 4096. If you are noticing performance problems, ecdsa and ed25519 are 'as secure' as RSA but require
less intensive computations to encrypt and decrypt data. Choose your poison.

here's the command to generate a key and place it in the current working directory. When you create it,
it's best if you don't leave a password since this file will need to be readable without your input.
so when prompted for a password just press 'enter' in the terminal. Note that this will create two files.
First, the private key, then the pubkey.

    ssh-keygen -t rsa -b 4096 -f id_rsa

After we generate the SSH key, we need to install it on our remote SSH server. We can do this by entering the following
into a terminal in the same directory. This will prompt the user for the password.

    ssh-copy-id -i id_rsa squirrel@<ssh_server_ip>

To test the connection, you can enter this into the terminal:
    
    ssh -i id_rsa squirrel@<ssh_server_ip>

After confirming that the key-based authentication works, now it's time to configure the squirrel.
In arming mode, secure copy the key to the /root/.ssh/ directory in the squirrel by running:

    scp id_rsa root@172.16.32.1:/root/.ssh/id_rsa

You will be prompted for a password and then the file will be uploaded.

Then, you need to connect to the ssh server at least once so the squirrel adds this server to the list
of known_hosts. More on this on the ssh man page. While in the squirrel, execute this:

    ssh -i /root/.ssh/id_rsa squirrel@<ssh_server_ip>

you will be prompted whether or not to add the host signature to known hosts, enter 'y'. Then,
configure the payload to use your ssh user and IP address, then the payload should make the squirrels
ssh server available at 127.0.0.1 on port 2222 on the ssh server.

Goes without saying, but use at your own risk. Don't do bad things.