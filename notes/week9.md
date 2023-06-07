### Week nine study note (6/04/2023 - 6/10/2023)<!-- omit from toc -->

#### Tracing Network Traffic
The `traceroute` is used to map the journey that a packet of data takes from its origin to its destination, `traceroute` is used when troubleshooting network issues, it can be used to determine where a packet is dropping in the network, this can help to tell us if a node is down in the network.
```console
traceroute google.com
traceroute to google.com (172.217.14.110), 30 hops max, 60 byte packets
 1  _gateway (192.168.18.2)  0.456 ms  0.368 ms  0.339 ms
 2  * * *
 3  * * *
 4  * * *
 5  * * *
 6  * * *
 7  * * *
 8  * * *
 9  * * *
10  * * *
11  * * *
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * *
23  * * *
24  * * *
25  * * *
26  * * *
27  * * *
28  * * *
29  * * *
30  * * *

```
