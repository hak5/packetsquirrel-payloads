# Portal-Jack - Captive Portal Hijack via DNS Spoofing

**Device:** Hak5 Packet Squirrel Mark II  
**Author:** Hackazillarex  
**Category:** Credentials (Red Team Auditing)  
**Version:** 1.0

## Overview

Portal-Jack exploits how operating systems detect captive portals (hotel WiFi, airport login pages, etc.) to trick a victim's device into automatically opening a credential harvester.

When a device connects to a network, it pings known HTTP endpoints to check for internet connectivity. If the response is unexpected, the OS assumes it's behind a captive portal and auto-opens a login window. Portal-Jack hijacks this mechanism using the Packet Squirrel's `SPOOFDNS` command to redirect those connectivity checks to an attacker-controlled server.

Modern browsers use DNS-over-HTTPS (DoH) which would bypass DNS spoofing entirely. Portal-Jack counters this by using `ebtables` at Layer 2 to block all HTTPS through the bridge, forcing browsers back to plain DNS. This also prevents the victim from browsing HTTPS sites until they "authenticate" - just like a real captive portal.

## How It Works

```
Victim PC --ethernet--> [Packet Squirrel] --ethernet--> Network
                              |
                    1. ebtables blocks all
                       HTTPS (port 443)
                       through the bridge
                              |
                    2. SPOOFDNS intercepts
                       DNS queries for OS
                       connectivity-check
                       domains + msn.com
                              |
                              v
                     Attacker's Kali box
                     (evil portal server
                      HTTP:80 + HTTPS:443)
                              |
                     Serves fake login page
                     Captures credentials
```

1. Packet Squirrel sits inline between victim's PC and the network (transparent bridge)
2. `ebtables` blocks all HTTPS (port 443) through the bridge - this kills DNS-over-HTTPS and prevents normal HTTPS browsing
3. With DoH dead, all DNS falls back to plain UDP port 53
4. `SPOOFDNS` intercepts DNS queries for OS connectivity-check domains and responds with the attacker's IP
5. Victim's OS thinks it's behind a captive portal and auto-opens a browser
6. On Windows, Edge opens and tries to load msn.com (its default homepage) - which is also spoofed to the attacker
7. The browser loads the attacker's credential harvester (`portal.html`)
8. Victim enters credentials thinking it's a network login
9. Server captures creds and logs them

## Target Domains

| OS | Connectivity Check Domain | Purpose |
|---|---|---|
| Windows (NCSI) | `www.msftconnecttest.com` | Primary connectivity probe |
| Windows (NCSI) | `www.msftncsi.com` | Legacy connectivity probe |
| Windows (Edge) | `edge-http.microsoft.com` | Edge-specific captive portal probe |
| Windows (Edge) | `www.msn.com`, `msn.com` | Edge default homepage (spoofed to catch auto-open) |
| Android | `connectivitycheck.gstatic.com`, `clients3.google.com` | Connectivity probe |
| Apple (iOS/macOS) | `captive.apple.com` | Connectivity probe |
| Firefox | `detectportal.firefox.com` | Connectivity probe |

## DoH Bypass

Modern browsers (Edge, Chrome, Firefox) use DNS-over-HTTPS which sends DNS queries over encrypted HTTPS connections, completely bypassing traditional DNS spoofing. The Packet Squirrel's kernel (5.10.138) lacks the `br_netfilter` module so `iptables` FORWARD rules don't work on bridge traffic. The solution is `ebtables` which operates at Layer 2 directly on bridge frames:

```bash
ebtables -A FORWARD --ip-proto tcp --ip-dport 443 -p ipv4 -j DROP
```

One rule blocks ALL outbound HTTPS through the bridge. This kills DoH to any provider and also prevents normal HTTPS browsing, which mimics how real captive portals restrict traffic before authentication.

## Files

| File | Where It Runs | Purpose |
|---|---|---|
| `payload.txt` | Packet Squirrel | ebtables + SPOOFDNS payload - blocks DoH and redirects DNS to attacker |
| `server.py` | Attacker's Kali box | Python HTTP/HTTPS server - handles connectivity checks, serves portal, captures creds |
| `portal.html` | Served by `server.py` | The fake "Network Authentication Required" login page victims see |

## Setup

### Prerequisites

- Hak5 Packet Squirrel Mark II
- Kali Linux box on the same network
- Two Ethernet cables
- Target device connected via Ethernet

### 1. Configure the Payload

Edit `payload.txt` and set your Kali box's IP:

```bash
ATTACKER_IP="10.0.0.235"   # <-- Change to your Kali IP
```

### 2. Deploy to Packet Squirrel

Set the Squirrel's switch to position 4 (Arming Mode), connect via USB, and SSH in:

```bash
ssh root@172.16.32.1
```

Or use SCP to push the payload directly:

```bash
scp payload.txt root@172.16.32.1:/root/payloads/switch1/payload
```

You can also deploy via the Packet Squirrel's web UI at `http://172.16.32.1` in arming mode.

### 3. Start the Evil Portal Server on Kali

```bash
# Make sure portal.html is in the same directory as server.py
sudo python3 server.py
```

The server runs on both port 80 (HTTP) and port 443 (HTTPS) simultaneously. It auto-generates a self-signed SSL certificate on first run. Captured credentials are printed to the console and saved to `loot.txt`.

### 4. Connect the Squirrel Inline

```
[Victim PC] --eth--> [Squirrel Port 1] -- [Squirrel Port 2] --eth--> [Network Switch/Router]
```

Flip the Squirrel's switch to position 1 (or whichever slot you deployed to) to activate the payload. The LED will:
- **Magenta (solid)** - Setting up bridge mode
- **Yellow (blinking)** - Attack is running (stays yellow until manually stopped)

### 5. Trigger the Portal

The victim's device may need a network state change to re-run its connectivity check:
- Disconnect/reconnect Ethernet
- Run `ipconfig /release` then `ipconfig /renew` (Windows)
- Disable/re-enable the network adapter

The captive portal login window should appear automatically.

## Loot

Captured credentials are saved to `loot.txt` in the same directory as `server.py`:

```
[2024-01-15 14:23:01] Email: victim@company.com | Password: Hunter2!
```

## Limitations

- **HTTPS browsing blocked:** While the payload is active, all HTTPS is blocked through the bridge. The victim cannot browse any HTTPS sites until the payload is stopped. This is by design and mimics real captive portal behavior.
- **Self-signed cert warning:** When Edge auto-opens and loads the spoofed msn.com over HTTPS, the victim will see a certificate warning for the self-signed cert. The HTTP captive portal paths (connectivity checks) do not trigger cert warnings.
- **HSTS/Pinned domains:** Only works because connectivity-check domains use plain HTTP. Don't try to spoof HTTPS sites that use HSTS.
- **Ethernet only:** Packet Squirrel is an inline Ethernet device - this doesn't work over WiFi.
- **Network detection timing:** Some OSes cache connectivity status; the victim may need a network state change to trigger the portal check.

## Disclaimer

**This tool is a proof of concept for authorized red team engagements and security education only.** Only use this on networks you own or have explicit written authorization to test. Unauthorized interception of network traffic and credential harvesting is illegal.

## Sysadmin Takeaway

If you're a network defender, this is why you should:
- Enforce DNS-over-HTTPS across your fleet (though this payload blocks it at the network level)
- Use 802.1X port authentication on wired connections to prevent inline devices
- Monitor for unexpected DNS responses on your network
- Train users to never enter real credentials into captive portal pages on wired networks
- Alert on SPOOFDNS-style behavior (same IP responding for multiple unrelated domains)
- Consider physical port security to prevent inline device insertion
