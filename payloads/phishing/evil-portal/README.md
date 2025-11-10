# Evil Portal with Packet Squirrel Mark II

- Author:        TW-D
- Version:       1.0
- Category:      Phishing

## Description

Implementation of the fake captive portal attack on the **Packet Squirrel Mark II** using a compatible USB Wi-Fi adapter.

A evil portal is a technique used to deceive users of a Wi-Fi network by redirecting them to a malicious web page instead of the expected authentication or home page.

### Tested On

| Operating System with/without Web Browser | Notification Type |
| --- | --- |
| Ubuntu 24.04 | None |
| Android 11 | System |
| Ubuntu 24.04 with Mozilla Firefox | Alert |

## Prerequisites

In **Arming Mode**, make sure both the **Ethernet "Target" Port** and **Ethernet "Network" Port** are connected.

```
hacker@hacker-computer:~$ ssh root@172.16.32.1
root@squirrel:~# opkg update
root@squirrel:~# opkg install usb-modeswitch
root@squirrel:~# poweroff
```

Once the **Packet Squirrel** is powered off, connect the **MK7AC WiFi Adapter**.

> [!NOTE]
> The **Ethernet "Network" Port** will no longer be required.

After startup, it is recommended to back up */etc/config/wireless*, the Wi-Fi configuration file.

```
hacker@hacker-computer:~$ ssh root@172.16.32.1
root@squirrel:~# cp /etc/config/wireless /etc/config/wireless.default
root@squirrel:~# exit
```

## Configuration

In the file *payload*, modify the values of the following constants.

```bash

######## INITIALIZATION ########

readonly EVIL_SSID="FREE_WIFI"

EVIL_PORTAL="/root/payloads/$(SWITCH)/portals/signin-form.html"
readonly EVIL_PORTAL

EVIL_LOOT="/root/payloads/$(SWITCH)/loots/signin-form_$(date +%s).log"
readonly EVIL_LOOT

```

> [!WARNING]
> The portal page must be a standalone HTML file, without external resources.
> This was deliberately implemented this way to ensure portability during a physical penetration test.

Then transfer the necessary files and folders into one of the *switchX* directories of the Packet Squirrel.

```
hacker@hacker-computer:~$ scp -r ./evil-portal/* root@172.16.32.1:/root/payloads/switchX/
hacker@hacker-computer:~$ ssh root@172.16.32.1
root@squirrel:~# poweroff
```

> [!NOTE]
> The **Ethernet "Target" Port** will no longer be required.

## Usage

Start your **Packet Squirrel Mark II** with the *Mode Switch* set to *switchX*.

A new open Wi‑Fi network whose name corresponds to the value of the constant *EVIL_SSID* will appear.

All HTTP requests sent by the client to the minimal web server will be stored in the *loots* directory.

To properly stop the payload, press the button.
