# NullSec-TrafficMirror — Packet Squirrel Traffic Capture & Analysis

**Author:** bad-antics (NullSec)  
**Category:** Sniffing  
**Target:** Any inline Ethernet connection  
**Version:** 1.0  

## Description

Advanced transparent traffic capture and analysis payload for the Hak5 Packet Squirrel. Operates in bridge mode for zero-visibility inline sniffing. Captures full pcap, extracts DNS queries, HTTP requests, and plaintext credentials from insecure protocols.

## Features

- **Full PCAP Capture** — Complete packet capture in bridge mode
- **DNS Query Logging** — All DNS lookups, deduplicated
- **HTTP Request Logging** — GET/POST/PUT/DELETE with URLs
- **Credential Extraction** — FTP, Telnet, SMTP, HTTP Basic Auth, POP3, IMAP
- **Protocol Breakdown** — Automatic protocol distribution analysis
- **Top Talkers** — Most active hosts by packet count
- **Zero Visibility** — Bridge mode means no network disruption

## LED States

| LED      | Color   | Meaning              |
|----------|---------|----------------------|
| SETUP    | Magenta | Initializing bridge  |
| ATTACK   | Yellow  | Capturing traffic    |
| FINISH   | Green   | Capture complete     |
| FAIL     | Red     | Error                |

## Configuration

Edit the top of `payload.sh`:

```bash
CAPTURE_TIME=300      # Capture duration in seconds (default: 5 min)
MAX_PCAP_SIZE=50      # Max pcap size in MB
EXTRACT_CREDS=1       # Extract plaintext credentials (1=yes)
CAPTURE_DNS=1         # Log DNS queries (1=yes)
CAPTURE_HTTP=1        # Log HTTP requests (1=yes)
```

## Output

Loot saved to `/mnt/loot/trafficmirror_<timestamp>/`:

```
trafficmirror_20260304_150000/
├── analysis.txt       # Formatted analysis report
├── capture.pcap       # Full packet capture (open in Wireshark)
├── dns_queries.txt    # Unique DNS domains queried
├── http_requests.txt  # HTTP requests captured
├── credentials.txt    # Extracted plaintext credentials
├── telnet_capture.txt # Telnet session data
└── smtp_capture.txt   # SMTP transaction capture
```

## Usage

1. Copy `payload.sh` to the appropriate switch directory
2. Set switch position
3. Connect Packet Squirrel inline between target and network
4. Wait for green LED
5. Retrieve loot from USB storage

## Requirements

- Hak5 Packet Squirrel (MK1 or MK2)
- `tcpdump` (pre-installed)
- USB storage for loot

## Notes

- Bridge mode ensures the target sees no network change
- SSH traffic to the Squirrel itself (172.16.32.1:22) is excluded from capture
- Credential extraction only captures **plaintext** protocols — encrypted traffic (HTTPS, SSH, etc.) is captured in pcap but credentials are not extracted
- For longer captures, increase `CAPTURE_TIME` or set `MAX_PCAP_SIZE` appropriately
