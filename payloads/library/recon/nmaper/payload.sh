#!/bin/bash
#
# Title:         Nmapper
# Description:   Nmap's the entire network
# Author:        thehappydinoa
# Version:       1.0
# Category:      Recon
# Target:        Any
# Net Mode:      TRANSPARENT
#
# See nmap --help for options. Default "-sN -vv" basic profiling of targets.
NMAP_OPTIONS="-sN -vv"
LOOT_DIR=/mnt/loot/nmapper/

function setup() {
  # Show SETUP LED
  LED SETUP
  # Set networking to TRANSPARENT mode and wait five seconds
  NETMODE TRANSPARENT
  sleep 5

  # Test network
  testNetwork

  # Create loot directory
  mkdir -p $LOOT_DIR &> /dev/null
}

function testNetwork() {
  # Sets Default Gateway
  GATEWAY_IP=$(route -n | grep 'UG[ \t]' | awk '{print $2}')
  [ -z "${GATEWAY_IP}" ] && NETMODE BRIDGE && testNetwork
  #[ -z "${GATEWAY_IP}" ] && LED FAIL && exit 1
  # Sets Network Name
  GATEWAY_NAME=$(nmap -sn $GATEWAY_IP | grep 'for' | awk '{print $5}' | cut -d '.' -f1)
  [[ -z "$GATEWAY_NAME" ]] && GATEWAY_NAME="noname"
}

function attack() {
  # Show ATTACK LED
  LED ATTACK
  # Sets File Name
  FILE_NAME=${GATEWAY_NAME}_$(date +%Y-%m-%d-%H%M%S).log
  # Scans entire sub net
  nmap $NMAP_OPTIONS $GATEWAY_IP/24 >> $LOOT_DIR/$FILE_NAME &>/dev/null
  # Show ATTACK FINISH
  LED FINISH
}

setup
attack
