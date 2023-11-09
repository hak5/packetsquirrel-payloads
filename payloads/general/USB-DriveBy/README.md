# USB-DriveBy
* Category: General
* Author: 90N45
* Version: 1.0

### Description
Use an USB storage device to deploy payloads on-demand while the Packe Squirrel is already set up and running.

### Setup
1. Start your Packet Squirrel with the USB-DriveBy payload.
2. Whenever you want to start any payload on-demand, place the payload file with the name `payload.txt` on any compatible USB storage device.
3. When the LED lights up solid green, you can insert the USB storage into the Squirrel’s USB-A port whenever a new payload is needed.

### Tip: Add an LED indicator to your payloads to indicate that your payloads have finished.
When finished, the USB-DriveBy payload will wait 10 seconds until it executes the script on your USB storage device again (if it is still present). This means that you should know when your payloads have finished and your USB storage device should be unplugged.

### Status
| LED | State |
| --- | --- |
| Magenta solid (SETUP) | Default network mode will be established |
| Green 1000ms VERYFAST blink followed by SOLID (FINISH) | Listening for USB storage device. Ready to run scripts. |
| Red slow symmetric blinking (FAIL) | No payload file found on USB storage device |