
|                 |                                                                                                    |
|:----------------|:---------------------------------------------------------------------------------------------------|
| **Title**	  |Wake UP!							       |
| **Description** | Sends a wake on lan packet to a single device or a range of IPs in a subnet. This script will take the local interface IP and netmask, calculate the broadcast address (making it plug and play on all network), find the mac address of the targets (can be noisy but its only a single ping to each)  and finally send a magic packet (if mac is found) to wake the device from slumber so you can run other scripts on newly awakened devices.       |
 **Author**	  | TheDragonkeeper                                                   |
| **Version**	  | 1.0												      |
| **Category**	  | General											      |
| **Target** 	  | Any												      |

| LED MODE             | Description                 |
|:-----------------:|:----------------------------|
| SETUP       | setting network to nat   |  
| FAIL       | Script had a fault      |
| ATTACK       | Loading python script      |
| FINISH      | Completed   |


| Options | Result  | Type |
|:----------|:----------|:----------|
| Set a single target or range of targets  | Options line 5 in payload.sh | |
|INTERFACE='eth0' | interface of the outgoing interface | str |
|SINGLE='0' |  single target or range ( 1 or 0 ) | int |
|TARGET='192.168.1.2' |  single target | str |
|STARTRANGE='1'   |  ip range start | int |
|ENDRANGE='255'   |  ip range end | int |

If Option SINGLE is set to 1 then the value of TARGET is used
if Option SINGLE is set to 0 then STARTRANGE and ENDRANGE is used 
Give all Options a value regardless of the value of SINGLE
