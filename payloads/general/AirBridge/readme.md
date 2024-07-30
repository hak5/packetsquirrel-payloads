
# AirBridge
#### Author: 0i41E
**AirBridge** is a payload designed for the [Package Squirrel MK II](https://shop.hak5.org/products/packet-squirrel-mark-ii) in combination with Hak5's [MK7AC Module](https://shop.hak5.org/products/mk7ac-wifi-adapter), or similar WiFi adapters.
It is meant to help users to overcome a potential airgapped network, by utilizing the WiFi adapter to connect to a nearby Station. 
Since it'll start the SSH service, as well as the Web interface, users can then interact with the Squirrel as usual. C2 access or conection to a VPN are also possible afterwards.
BILD

## Preperation
Before deploying the Squirrel as also the payload, the user has to update the system and install `usb_modeswitch`, as without it, the WiFi adpater will be identified as storage. For this step, internet access is required.
`opkg update && opkg install usb-modeswitch` 

Apart from this step, the payload needs to be configured. 
Input the desired `SSID`, as well as its `PASSPHRASE`.
Optionally, the `EXTERNAL_HOST` may be changed from Googles DNS server to a different system. The users C2 instance may be a good alternative, if used. `NETMODE` can be configured to the users needs.
```
SSID="<SSID>" # Station SSID
PASSPHRASE="<Passphrase>" # Passphrase
EXTERNAL_HOST="8.8.8.8" # External Host to verify connection
```
The last step is obvious, but should be mentioned... 
Prepare a Station, reachable by the AC Module.

## Usage
After saving the payload, put the switch into the correct position and power up the device. 
After successfully booting, a blinking LED in the color magenta, will indicate the Squirrel being ready to proceed.

Plug in your WiFi adapter via USB-A and press the button. *This method was implemented intentionally, as during testing it caused problems to power up the device with the AC Module already attached.*
The LED will start blinking green. 
A solid green LED will indicate the success. Otherwise, a red LED will appear.

If everything went well, you should now be able to access the Squirrel by whatever IP-Address your Station gave to the Squirrel.

