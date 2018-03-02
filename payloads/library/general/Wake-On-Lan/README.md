
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


| Options | Line | Result  |
|:----------|:----------|:----------|
| Set a single target or range of targets|   5  | Options explained in payload.sh |
