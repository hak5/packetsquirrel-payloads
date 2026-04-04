# DoppelgangerSquirrel
#### Author: 0i41E
#### Version: 1.0

**DoppelgangerSquirrel** is a payload designed for the [Packet Squirrel MK II](https://shop.hak5.org/products/packet-squirrel-mark-ii) to impersonate a client system within a network, similar to the MK I's [`NETMODE CLONE`](https://docs.hak5.org/packet-squirrel/payload-development/the-netmode-command/#netmode-clone).
It clones the clients hostname and MAC address, which then get presented to the target network. 

## Preperation
Similar to `NETMODE CLONE`, the Packet Squirrel clones the MAC address, as well as hostname, of the target device from its Ethernet IN port ([Target Port](https://docs.hak5.org/packet-squirrel-mk-ii/getting-started/packet-squirrel-basics/#target-port)). Before connecting the cable to the target network via the Ethernet OUT port ([Network Port](https://docs.hak5.org/packet-squirrel-mk-ii/getting-started/packet-squirrel-basics/#network-port)), it is recommended to wait until the payload has finished. The Packet Squirrel will indicate successfull cloning by a blinking green LED, which turns off afterwards.

#### Setup
- Disconnect the target client from its network.
- Connect Squirrel to target client via Target Port

Afterwards, powerup the squirrel, let it boot and run the payload. After the LED blinks green, it'll turn off the LED, indicating that you now can insert the cable of the target network into the Network Port. 

#### LED Status (After boot)
- Cyan LED (LED SPECIAL2): Payload Start
- Magenta (LED SETUP): Netmode started, beginning DHCP Lease loop
- Yellow (LED STAGE3): Running loop to extract hostname and MAC address from DHCP lease
- BLUE (LED B FAST): Loop successfully finished
- Green (LED G Blinking): Followed by LED OFF, indicates success
- RED: Error

### Good to know
- Even though this payload performs a backup, be aware that `NETMODE NAT` gets modified
- Be aware that the target client sits within the Squirrels subnet, resulting in a different IP-address
- Resolving internal hostnames from the target network will likely fail
- Inserting the network cable into the Network Port before the payload has finished, may expose the Squirrel - be warned.
