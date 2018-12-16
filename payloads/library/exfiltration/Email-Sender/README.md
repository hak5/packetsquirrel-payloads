|                 |                                                                                                    |
|:----------------|:---------------------------------------------------------------------------------------------------|
| **Title**	  | Email-Sender							       |
| **Description** | Sends emails / has html and file support / it can be used with bash and python .      |
 **Author**	  | TheDragonkeeper                                                   |
| **Version**	  | 1.1												      |
| **Category**	  | Exfiltration											      |
| **Target** 	  | Any												      |

| Meaning   | Color             | Description                 |
|:----------|:-----------------:|:----------------------------|
| SUCCESS:  | Blink Green       | Payload ended complete      |
| SETUP:   | Blink Yellow      | Payload is waiting on network   |

| Command   | Arguments       |
:----------|:-----------------|
| SENDMAIL | $FROM $RCPT "$SUBJECT" "$BODY" $SERVER $USER $PASS "$FILE" |


Running the payload will install the command to /usr/bin
this will allow you to use the command SENDMAIL to send an email using your bash payload
the default arguments are as follows.



|  $1  |   $2   |  $3      |   $4  |     $5   | $6  |   $7   | $8
|:----------|:----------|:-----------------|:----------|:----------|:-----------------|:----------|:-----------------:|
| $FROM |$RCPT |"$SUBJECT"| "$BODY"| $SERVER | $USER | $PASS |"$FILE" |


if you wish to hard code one of these values you can simply edit the SENDMAIL file and then drop the numbers down a value;
i.e if you change $1  to  'thisismyemail@somedomain.net'  then $2 now needs to be $1

The other option is to edit the python file 'sendemail.py' and change the corresponding sys.argv[1] in the same way.
but then you need to make sure you also edit the SENDMAIL to only send the amount of arguments needed.
