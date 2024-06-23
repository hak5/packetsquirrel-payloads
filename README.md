
# Payload Library for the [Packet Squirrel](https://hak5.org/products/packet-squirrel) by [Hak5](https://hak5.org)

This repository contains payloads and extensions for the Hak5 Packet Squirrel and Hak5 Packet Squirrel Mark II.  Community developed payloads are listed and developers are encouraged to create pull requests to make changes to or submit new payloads.

<div align="center">
<img src="https://img.shields.io/github/forks/hak5/packetsquirrel-payloads?style=for-the-badge"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://img.shields.io/github/stars/hak5/packetsquirrel-payloads?style=for-the-badge"/>
<br/>
<img src="https://img.shields.io/github/commit-activity/y/hak5/packetsquirrel-payloads?style=for-the-badge">
<img src="https://img.shields.io/github/contributors/hak5/packetsquirrel-payloads?style=for-the-badge">
</div>
<br/>
<p align="center">
<a href="https://payloadhub.com"><img src="https://cdn.shopify.com/s/files/1/0068/2142/files/payloadhub.png?v=1652474600"></a>
<br/>
<a href="https://payloadhub.com/blogs/payloads/tagged/packet-squirrel">View Featured Packet Squirrel Payloads and Leaderboard</a>
<br/><i>Get your payload in front of thousands. Enter to win over $2,000 in prizes in the <a href="https://hak5.org/pages/payload-awards">Hak5 Payload Awards!</a></i>
</p>


<div align="center">
<a href="https://hak5.org/discord"><img src="https://img.shields.io/discord/506629366659153951?label=Hak5%20Discord&style=for-the-badge"></a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="https://youtube.com/hak5"><img src="https://img.shields.io/youtube/channel/views/UC3s0BtrBJpwNDaflRSoiieQ?label=YouTube%20Views&style=for-the-badge"/></a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="https://youtube.com/hak5"><img src="https://img.shields.io/youtube/channel/subscribers/UC3s0BtrBJpwNDaflRSoiieQ?style=for-the-badge"/></a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="https://twitter.com/hak5"><img src="https://img.shields.io/badge/follow-%40hak5-1DA1F2?logo=twitter&style=for-the-badge"/></a>
<br/><br/>

</div>

# Packet Squirrel Versions 

There are currently two versions of the Packet Squirrel.  The original Packet Squirrel can be identified by the micro-usb power port, while the Packet Squirrel Mark II can be identified by the USB-C power port.

Please make sure you select payloads for the device you have!

Payloads for the original Packet Squirrel be found in the `legacy-mk1/` directory.

The Packet Squirrel Mark II payloads can be found in the `payloads/` directory.

The Packet Squirrel Mark II expands the DuckyScript for Packet Squirrel commands and adds many new commands and features.  In general, payloads from the original Packet Squirrel can be adapted to run on the Packet Squirrel Mark II by adopting the new commands - check out the [Packet Squirrel Mark II Payload documentation](https://docs.hak5.org/packet-squirrel-mark-ii/payload-development/duckyscript-for-packet-squirrel) for more information!

The existing suite of original Packet Squirrel payloads remains available and functional on the original hardware in the `legacy-mk1/` directory!

# Shop
- [Purchase the Packet Squirrel](https://hak5.org/products/packet-squirrel "Purchase the Packet Squirrel")
- [PayloadStudio Pro](https://hak5.org/products/payload-studio-pro "Purchase PayloadStudio Pro")
- [Shop All Hak5 Tools](https://shop.hak5.org "Shop All Hak5 Tools")

## Getting Started
- [Build Payloads with PayloadStudio](#build-your-payloads-with-payloadstudio) | [QUICK START GUIDE](https://docs.hak5.org/packet-squirrel-mark-ii/payload-development/payload-development-basics "QUICK START GUIDE") 

## Documentation / Learn More
-   [Documentation](https://docs.hak5.org/packet-squirrel-mark-ii "Documentation") 

## Community
*Got Questions? Need some help? Reach out:*
-  [Discord](https://hak5.org/discord/ "Discord") | [Forums](https://forums.hak5.org/forum/94-packet-squirrel/ "Forums")

## Additional Links
<b> Follow the creators </b><br/>
<p >
	<a href="https://twitter.com/notkorben">Korben's Twitter</a> | 
	<a href="https://instagram.com/hak5korben">Korben's Instagram</a>
<br/>
	<a href="https://infosec.exchange/@kismetwireless">Dragorn's Mastodon</a> | 
<br/>
	<a href="https://twitter.com/hak5darren">Darren's Twitter</a> | 
	<a href="https://instagram.com/hak5darren">Darren's Instagram</a>
</p>

<br/>
<h1><a href="https://hak5.org/products/packet-squrirel">About the Packet Squrirel</a></h1>

The Packet Squirrel Mark II by Hak5 is a stealthy pocket-sized man-in-the-middle.

This Ethernet multi-tool is designed to give you covert remote access, painless packet captures, and secure VPN connections with the flip of a switch.

<b>
<div align="center">
<a href="https://www.youtube.com/watch?v=hN9tFx5N3uM">Launch Video</a>
<br/>
<br/>
</div>
</b>
<p align="center">
<a href="https://hak5.org/products/packet-squirrel"><img src="https://3076592524-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2F520JUF2JxB2RMXztRVAV%2Fuploads%2F6gSNjJNnaht6yMo5AMCg%2Fsquirrel-setup.png?alt=media&token=382e30a0-10c0-4ab0-88b4-db27e9331a23"></a>
<br/><i>Hak5 Packet Squirrel Features</i>
</p>
<br/>

The Packet Squirrel Mark II is an Ethernet multi-tool for packet capture, man-in-the-middle network manipulation, stream filtering and redirection, remote VPN access, and more.

Use simplified DuckyScript for Packet Squirrel to create payloads, or unlock the full power of Bash script or Python 3 for complex payloads.

Edit payloads live in the Web UI editor with syntax highlighting, SSH, or [build your payloads with Payload Studio](https://payloadstudio.hak5.org).

Exfiltrate data or pentest from anywhere with [Hak5 Cloud C²](https://shop.hak5.org/products/c2 "Hak5 Cloud C²").

# About DuckyScript™

DuckyScript is the payload language of Hak5 gear.

Originating on the Hak5 USB Rubber Ducky as a standalone language, the Packet Squirrel uses DuckyScript commands to bring the ethos of easy-to-use actions to the payload language.

DuckyScript commands are always in all capital letters to distinguish them from other system or script language commands.  Typically, they take a small number of options (or sometimes no options at all).

Payloads can be constructed of DuckyScript commands alone, or combined with the power of bash scripting and system commands to create fully custom, advanced actions.

The files in this repository are _the source code_ for your payloads and run _directly on the device_ **no compilation required** - simply place your `payload.txt` in the appropriate directory and you're ready to go!

<h1><a href="https://payloadstudio.hak5.org">Build your payloads with PayloadStudio</a></h1>
<p align="center">
Take your DuckyScript™ payloads to the next level with this full-featured,<b> web-based (entirely client side) </b> development environment.
<br/>
<a href="https://payloadstudio.hak5.org"><img src="https://cdn.shopify.com/s/files/1/0068/2142/products/payload-studio-icon_180x.png?v=1659135374"></a>
<br/>
<i>Payload studio features all of the conveniences of a modern IDE, right from your browser. From syntax highlighting and auto-completion to live error-checking and repo synchronization - building payloads for Hak5 hotplug tools has never been easier!
<br/><br/>
Supports your favorite Hak5 gear - USB Rubber Ducky, Bash Bunny, Key Croc, Shark Jack, Packet Squirrel & LAN Turtle!
<br/><br/></i><br/>
<a href="https://hak5.org/products/payload-studio-pro">Become a PayloadStudio Pro</a> and <b> Unleash your hacking creativity! </b>
<br/>
OR
<br/>
<a href="https://payloadstudio.hak5.org/community/"> Try Community Edition FREE</a> 
<br/><br/>
<img src="https://cdn.shopify.com/s/files/1/0068/2142/files/themes1_1_600x.gif?v=1659642557">
<br/>
<i> Payload Studio Themes Preview GIF </i>
<br/><br/>
<img src="https://cdn.shopify.com/s/files/1/0068/2142/files/AUTOCOMPLETE3_600x.gif?v=1659640513">
<br/>
<i> Payload Studio Autocomplete Preview GIF </i>
</p>


<h1><a href='https://shop.hak5.org/products/c2'>Hak5 Cloud C² </a></h1>
Cloud C² makes it easy for pen testers and IT security teams to deploy and manage fleets of Hak5 gear from a simple cloud dashboard. 

Cloud C² is available as an instant download. **A free license for Community Edition is available which is not for commercial use and comes with community support.**
The **Professional** and **Teams Editions** are for commercial use with standard support.
<p align="center">
<a href="https://shop.hak5.org/products/c2"><img src="https://cdn.shopify.com/s/files/1/0068/2142/files/teams1.png?v=1614035533"></a>
<br/>
<i> Hak5 Cloud C² Web Interface</i>
</p>

Cloud C² is a **self-hosted** web-based command and control suite for networked Hak5 gear that lets you **pentest from anywhere.**

Linux, Mac and Windows computers can host the Cloud C² server while Hak5 gear such as the WiFi Pineapple, LAN Turtle and Packet Squirrel can be provisioned as clients.

Once you have the Cloud C² server running on a public-facing machine (such as a VPS) and the Hak5 devices are provisioned and deployed, you can login to the Cloud C² web interface to manage these devices as if you were directly connected.

With multiple Hak5 devices deployed at a client site, aggregated data provides a big picture view of the wired and wireless environments.

<p align="center">
<a href="https://shop.hak5.org/products/c2"><img src="https://cdn.shopify.com/s/files/1/0068/2142/files/teams2.png?v=1614035564"/></a>
<br/>
<i> Hak5 Cloud C² Web Interface - Teams Edition - Sites </i>
</p>

Hak5 Cloud C² Teams edition comes full of features designed to help you manage **all** of your remote Hak5 devices with ease:
 - Multi-User
 - Multi-Site
 - Role-Based Access Control
 - Advanced Auditing
 - Tunneling Services including web Terminal and WiFi Pineapple web interface proxy

<a href="https://shop.hak5.org/products/c2">Learn More</a>

<h1><a href='https://payloadhub.com'>Contributing</a></h1>

<p align="center">
<a href="https://payloadhub.com"><img src="https://cdn.shopify.com/s/files/1/0068/2142/files/payloadhub.png?v=1652474600"></a>
<br/>
<a href="https://payloadhub.com">View Featured Payloads and Leaderboard </a>
</p>


Once you have developed your payload, you are encouraged to contribute to this repository by submitting a Pull Request. Reviewed and Approved pull requests will add your payload to this repository, where they may be publically available.

# Please adhere to the following best practices and style guides when submitting a payload.

### Purely destructive or invasive payloads will not be accepted. No, it's not "just a prank".

Payloads should be submitted to the most appropriate category directory, such as exfiltration, interception, recon, sniffing, etc.

Subject to change. Please ensure any submissions meet the [latest version](https://github.com/hak5/packetsquirrel-payloads/blob/master/README.md) of these standards before submitting a Pull Request.

## Naming Conventions

Please give your payload a unique, descriptive and appropriate name. Do not use spaces in payload, directory or file names. Each payload should be submit into its own directory, with `-` or `_` used in place of spaces, to one of the categories such as exfiltration, interception, sniffing, or recon. Do not create your own category.

The payload itself should be named `payload`.

Additional files and documentation can be included in the payload directory.  Documentation should be in `README.md` or `README.txt`.

## Payload Configuration

In many cases, payloads will require some level of configuration by the end payload user. Be sure to take the following into careful consideration to ensure your payload is easily tested, used and maintained. 

- Remember to use PLACEHOLDERS for configurable portions of your payload - do not share your personal URLs, API keys, Passphrases, etc...
- Do not leave defaults that point at live services
- Make note of both required and optional configuration(s) in your payload using comments at the top of your payload or "inline" where applicable

## Payload Format

Payloads should begin with comments specifying at the very least the name of the payload and author. Additional information such as a brief description, the target, any dependencies / prerequisites and the LED status used is helpful.

    # Title: Example payload
	# Description: Example payload with configuration options
	# Author: Hak5
	# Version: 1.0
	# Category: Remote-Access
	# Net Mode: NAT
	#
	# LED State Descriptions
	# Magenta Solid - Configuring NETMODE
	# LED OFF - Waiting for BUTTON
	# Red Blink 2 Times - Connection Failed
	# Amber Blink 5 Times - Connection Successful
	# Red Blink 1 Time - Command Failed
	# Cyan Blink 1 Time - Command Successful

### Configuration Options

Configurable options should be specified in variables at the top of the payload file:

    # Options
    SSH_USER="username"
	SSH_HOST="hostname"
    PORT=31337

### NETMODE

All payloads should include a `NETMODE` command to set the Packet Squirrel to a useful network mode.

When in doubt, `NETMODE NAT` is a reasonable default.

### LED

The payload should use common payload states rather than unique color/pattern combinations when possible with an LED command preceding the Stage or `NETMODE`.

	LED SETUP
	NETMODE NAT

Common payload states include a `SETUP`, with may include a `FAIL` if certain conditions are not met. This is typically followed by either a single `ATTACK` or multiple `STAGEs`. More complex payloads may include a `SPECIAL` function to wait until certain conditions are met. Payloads commonly end with a `CLEANUP` phase, such as moving and deleting files or stopping services. A payload may `FINISH` when the objective is complete and the device is safe to eject or turn off. These common payload states correspond to `LED` states.


<h1><a href="https://hak5.org/pages/policy">Legal</a></h1>

Payloads from this repository are provided for educational purposes only.  Hak5 gear is intended for authorized auditing and security analysis purposes only where permitted subject to local and international laws where applicable. Users are solely responsible for compliance with all laws of their locality. Hak5 LLC and affiliates claim no responsibility for unauthorized or unlawful use.

DuckyScript is a trademark of Hak5 LLC. Copyright © 2010 Hak5 LLC. All rights reserved. No part of this work may be reproduced or transmitted in any form or by any means without prior written permission from the copyright owner.
Packet Squirrel and DuckyScript are subject to the Hak5 license agreement (https://hak5.org/license)
DuckyScript is the intellectual property of Hak5 LLC for the sole benefit of Hak5 LLC and its licensees. To inquire about obtaining a license to use this material in your own project, contact us. Please report counterfeits and brand abuse to legal@hak5.org.
This material is for education, authorized auditing and analysis purposes where permitted subject to local and international laws. Users are solely responsible for compliance. Hak5 LLC claims no responsibility for unauthorized or unlawful use.
Hak5 LLC products and technology are only available to BIS recognized license exception ENC favorable treatment countries pursuant to US 15 CFR Supplement No 3 to Part 740.

# Disclaimer
Generally, payloads may execute commands on your device. As such, it is possible for a payload to damage your device. Payloads from this repository are provided AS-IS without warranty. While Hak5 makes a best effort to review payloads, there are no guarantees as to their effectiveness. As with any script, you are advised to proceed with caution.

