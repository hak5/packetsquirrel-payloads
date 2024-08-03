# Proxquirrel
#### Author: 

**Proxquirrel** is a payload designed for the [Package Squirrel MK II](https://shop.hak5.org/products/packet-squirrel-mark-ii) in combination with a HTTP proxy, like [BurpSuite](https://portswigger.net/burp/releases/professional-community-2024-5-5?requestededition=community&requestedplatform=).

This payload will redirect common web ports like 80 and 443 and therefore enables the user to intercept such traffic with an external proxy and tinker with its content.

## Preperation
#### Squirrel
Before deploying the Squirrel as also the payload, the user has to configure the payload.
Set `PROXY_ADDRESS` and `PROXY_PORT`. This has to be the proxy (server). 
The other options are optional and can be changed, if needed. 
#### BurpSuite
Start up BurpSuite and navigate to the *Proxy* tab and open up the options.
BILD
Here you have to edit the *proxy listener*.
Set the *bind address* to either the interface accessible by the Squirrel or simply select *All Interfaces*. 
BILD
*The payload will automatically verify the connection. If the proxy can't be reached, the payload will fall into a loop, until the proxy (server) is accessible.*

For the last step, we have to check *Support invisible proxying* under the *Request handling* tab.
In this mode, BurpSuite intercepts traffic that is not specifically directed at a proxy. It acts as an intermediary without requiring the client to be configured for a proxy. This is useful for intercepting traffic from devices or applications that do not allow for proxy configuration. (Or in this case, do not know about it)

Traffic to ports 80 & 443 should now be redirected to your proxy.

#### Cleanup
To revert the changes on the Squirrel, press the button to perform a cleanup.



### Opsec Considerations
Since this payload performs some sort of interception of the targets traffic, the target-user may encounter multiple issues: 
	- Security warnings about the connection to a web page not being secure.
	- Not being able to use certain web applications due to HSTS.
	- Sensitive information may be visible within the intercepted requests and should be handled with care.
	- The user may be blocked by certain WAF's 