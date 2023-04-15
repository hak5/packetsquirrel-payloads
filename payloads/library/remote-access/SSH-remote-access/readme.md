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


Use at your own risk. Don't do bad things.