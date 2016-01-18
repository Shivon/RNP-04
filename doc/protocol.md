### Part 2
* __Task__: get server from RNP-02/03 running on port 9400
* __Result__: not possible because another process is listening on it (PID 1972 / Program name rn10server)

### Part 3
* important note: don't ban __within__ the network but __from__/ __to__ the network
* please look at the [shell scripts](https://github.com/Shivon/RNP-04/tree/master/firewalling) for further information

### Part 4
* __General helpful stuff__:
  * show current routing table: ```/sbin/route```
    * returns
     ``` bash
     Kernel IP routing table
     Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
     default         141.22.26.1     0.0.0.0         UG    0      0        0 eth0
     cpt.haw-hamburg *               255.255.254.0   U     0      0        0 eth0
     172.16.1.0      *               255.255.255.0   U     0      0        0 eth2
     192.168.17.0    *               255.255.255.0   U     0      0        0 eth1
     ```

  * get routing: ```ip route show```
    * returns
    ``` bash
    default via 141.22.26.1 dev eth0  proto dhcp
    141.22.26.0/23 dev eth0  proto kernel  scope link  src 141.22.27.105
    172.16.1.0/24 dev eth2  proto kernel  scope link  src 172.16.1.8
    192.168.17.0/24 dev eth1  proto kernel  scope link  src 192.168.17.14
    ```
    * first part = subnets where our computer is connected to => here we'll find the gateway to ISDN/ router
      * ISDN: 192.168.17.1 our port (lab26), 192.168.18.1 port of other subnet (lab33)
      * Router: 192.168.17.2 our port (lab26), 192.168.18.2 port of other subnet AND 172.16.1.140 as port for both subnets (lab33)
    * ethX = name of subnet
    * last part = our IP address in particular subnet

* __Task A__: route via ISDN only
  * after routing now ```/sbin/route``` returns
  ``` bash
  Kernel IP routing table
  Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
  default         141.22.26.1     0.0.0.0         UG    0      0        0 eth0
  cpt.haw-hamburg *               255.255.254.0   U     0      0        0 eth0
  172.16.1.0      *               255.255.255.0   U     0      0        0 eth2
  192.168.17.0    *               255.255.255.0   U     0      0        0 eth1
  192.168.18.136  192.168.17.1    255.255.255.255 UGH   0      0        0 eth1
  ```
  * after routing now ```/usr/sbin/traceroute 192.168.18.136``` returns
  ``` bash
  networker@lab26:/mnt/fileserver/MyHome/win7/Git/RNP-04/routing> /usr/sbin/traceroute 192.168.18.136
  traceroute to 192.168.18.136 (192.168.18.136), 30 hops max, 60 byte packets
  1  192.168.17.1 (192.168.17.1)  118.728 ms  120.254 ms  121.714 ms
  2  * * *
  3  192.168.18.136 (192.168.18.136)  304.143 ms  305.126 ms  306.252 ms
  ```
  * send via ISDN 1000 Byte big packages e.g. via ```ping -s 1000 192.168.18.136```
    * -s is the size in bytes of a package sent
  * returns
  ``` bash
  ping -s 1000 192.168.18.136
  PING 192.168.18.136 (192.168.18.136) 1000(1028) bytes of data.
  From 192.168.17.1 icmp_seq=1 Frag needed and DF set (mtu = 786)
  1008 bytes from 192.168.18.136: icmp_seq=2 ttl=62 time=287 ms
  1008 bytes from 192.168.18.136: icmp_seq=3 ttl=62 time=288 ms
  1008 bytes from 192.168.18.136: icmp_seq=4 ttl=62 time=287 ms
  1008 bytes from 192.168.18.136: icmp_seq=5 ttl=62 time=287 ms
  1008 bytes from 192.168.18.136: icmp_seq=6 ttl=62 time=287 ms
  1008 bytes from 192.168.18.136: icmp_seq=7 ttl=62 time=287 ms
  1008 bytes from 192.168.18.136: icmp_seq=8 ttl=62 time=287 ms
  ^C
  --- 192.168.18.136 ping statistics ---
  8 packets transmitted, 7 received, +1 errors, 12% packet loss, time 7008ms
  rtt min/avg/max/mdev = 287.060/287.389/288.228/0.470 ms
  ```
    * "Frag needed and DF set" means fragmentation needed but DF (flag, "Don't fragment") is set => problem...
    * "(mtu = 786)" means the maximum transmission unit is 786 byte (from ISDN), so every package bigger than that needs to be fragmented
    * due to this 12% package loss BUT next time the operating system knows this and fragments in advance for this specific IP

* __Task B__: route via router only
* getting the ipv6-address of the computers:

``` bash
networker@lab33:~> /sbin/ifconfig
eth1      Link encap:Ethernet  HWaddr 00:1B:21:40:E6:B4
          inet addr:192.168.18.136  Bcast:192.168.18.255  Mask:255.255.255.0

          inet6 addr: fd32:6de0:1f69:18:c1dd:ca13:c0de:51b/64 Scope:Global

          inet6 addr: fd32:6de0:1f69:18:21b:21ff:fe40:e6b4/64 Scope:Global
          inet6 addr: fe80::21b:21ff:fe40:e6b4/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:144 errors:0 dropped:0 overruns:0 frame:0
          TX packets:84 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:17309 (16.9 Kb)  TX bytes:16501 (16.1 Kb)
          Memory:f7c20000-f7c3ffff

networker@lab26:/mnt/fileserver/MyHome/win7/Git/RNP-04/routing> /sbin/ifconfig
eth1      Link encap:Ethernet  HWaddr 00:1B:21:40:E7:FC
          inet addr:192.168.17.14  Bcast:192.168.17.255  Mask:255.255.255.0
          inet6 addr: fd32:6de0:1f69:17:3593:a373:78a1:67ca/64 Scope:Global
          inet6 addr: fe80::21b:21ff:fe40:e7fc/64 Scope:Link

          inet6 addr: fd32:6de0:1f69:17:21b:21ff:fe40:e7fc/64 Scope:Global

          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:148 errors:0 dropped:0 overruns:0 frame:0
          TX packets:85 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:13340 (13.0 Kb)  TX bytes:16634 (16.2 Kb)
          Memory:f7c20000-f7c3ffff
```

* lab33 ipv6 address = fd32:6de0:1f69:18:c1dd:ca13:c0de:51b
* lab26 ipv6 address = fd32:6de0:1f69:17:21b:21ff:fe40:e7fc
* after executing the shell script on both computers:
  * lab26:
  ``` bash
  networker@lab26:/mnt/fileserver/MyHome/win7/Git/RNP-04/routing> ping6 fd32:6de0:1f69:18:21b:21ff:fe40:e6b4
  PING fd32:6de0:1f69:18:21b:21ff:fe40:e6b4(fd32:6de0:1f69:18:21b:21ff:fe40:e6b4) 56 data bytes
  From fd32:6de0:1f69:17:3593:a373:78a1:67ca icmp_seq=1 Destination unreachable: Address unreachable
  From fd32:6de0:1f69:17:3593:a373:78a1:67ca icmp_seq=2 Destination unreachable: Address unreachable
  From fd32:6de0:1f69:17:3593:a373:78a1:67ca icmp_seq=3 Destination unreachable: Address unreachable
  From fd32:6de0:1f69:17:3593:a373:78a1:67ca icmp_seq=4 Destination unreachable: Address unreachable
  From fd32:6de0:1f69:17:3593:a373:78a1:67ca icmp_seq=5 Destination unreachable: Address unreachable
  From fd32:6de0:1f69:17:3593:a373:78a1:67ca icmp_seq=6 Destination unreachable: Address unreachable
  From fd32:6de0:1f69:17:3593:a373:78a1:67ca icmp_seq=7 Destination unreachable: Address unreachable
  From fd32:6de0:1f69:17:3593:a373:78a1:67ca icmp_seq=8 Destination unreachable: Address unreachable
  ^C
  --- fd32:6de0:1f69:18:21b:21ff:fe40:e6b4 ping statistics ---
  9 packets transmitted, 0 received, +8 errors, 100% packet loss, time 8000ms
  ```
  * lab33:
  ``` bash
  networker@lab33:~> ping6 fd32:6de0:1f69:17:21b:21ff:fe40:e7fc
  PING fd32:6de0:1f69:17:21b:21ff:fe40:e7fc(fd32:6de0:1f69:17:21b:21ff:fe40:e7fc) 56 data bytes
  64 bytes from fd32:6de0:1f69:17:21b:21ff:fe40:e7fc: icmp_seq=1 ttl=63 time=0.523 ms
  64 bytes from fd32:6de0:1f69:17:21b:21ff:fe40:e7fc: icmp_seq=2 ttl=63 time=0.344 ms
  64 bytes from fd32:6de0:1f69:17:21b:21ff:fe40:e7fc: icmp_seq=3 ttl=63 time=0.338 ms
  64 bytes from fd32:6de0:1f69:17:21b:21ff:fe40:e7fc: icmp_seq=4 ttl=63 time=0.390 ms
  64 bytes from fd32:6de0:1f69:17:21b:21ff:fe40:e7fc: icmp_seq=5 ttl=63 time=0.367 ms
  64 bytes from fd32:6de0:1f69:17:21b:21ff:fe40:e7fc: icmp_seq=6 ttl=63 time=0.347 ms
  64 bytes from fd32:6de0:1f69:17:21b:21ff:fe40:e7fc: icmp_seq=7 ttl=63 time=0.341 ms
  64 bytes from fd32:6de0:1f69:17:21b:21ff:fe40:e7fc: icmp_seq=8 ttl=63 time=0.367 ms
  64 bytes from fd32:6de0:1f69:17:21b:21ff:fe40:e7fc: icmp_seq=9 ttl=63 time=0.363 ms
  64 bytes from fd32:6de0:1f69:17:21b:21ff:fe40:e7fc: icmp_seq=10 ttl=63 time=0.345 ms
  ^C
  --- fd32:6de0:1f69:17:21b:21ff:fe40:e7fc ping statistics ---
  10 packets transmitted, 10 received, 0% packet loss, time 9000ms
  ```

### Part 5
(this time on on lab23)
* filter for sniffing: ```host 141.22.27.102 or host 192.168.17.13 or host 172.16.1.4```
* HTTP requests without firewalling: ![before firewalling a](https://github.com/Shivon/RNP-04/blob/master/advanced_sniffing_and_firewalling/snapshot_5a_pt1.png) ![before firewalling b](https://github.com/Shivon/RNP-04/blob/master/advanced_sniffing_and_firewalling/snapshot_5a_pt2.png)
* HTTP requests after executing the shell script: ![after firewalling](https://github.com/Shivon/RNP-04/blob/master/advanced_sniffing_and_firewalling/snapshot_5b.png)
* solution for 5c):    
When you add the rule, DNS looks up the IP address of the given URL (dmi.dk). It then adds the rule with the IP address(es) hardcoded hence when the IP address changes, the website cannot be accessed anymore (like all other website due to the ban of outgoing requests).    
Rules for output chain:    
``` bash
networker@lab23:/mnt/fileserver/MyHome/win7/Git/RNP-04/advanced_sniffing_and_firewalling> sudo /usr/sbin/iptables -L
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
ACCEPT     tcp  --  anywhere             5.56.149.239         tcp dpt:http
ACCEPT     tcp  --  anywhere             5.56.149.238         tcp dpt:http
ACCEPT     tcp  --  anywhere             130.226.71.229       tcp dpt:http
ACCEPT     tcp  --  anywhere             130.226.71.226       tcp dpt:http
REJECT     tcp  --  anywhere             anywhere             tcp dpt:http reject-with tcp-reset
ACCEPT     all  --  anywhere             anywhere
ACCEPT     all  --  anywhere             cpt.haw-hamburg.de/23
ACCEPT     all  --  anywhere             cpt.haw-hamburg.de/23
ACCEPT     all  --  anywhere             anywhere             state ESTABLISHED
ACCEPT     all  --  anywhere             dns.is.haw-hamburg.de
ACCEPT     all  --  anywhere             dns2.is.haw-hamburg.de
ACCEPT     all  --  anywhere             dns3.is.haw-hamburg.de
ACCEPT     all  --  anywhere             shell-14.informatik.haw-hamburg.de
ACCEPT     all  --  anywhere             homefs.informatik.haw-hamburg.de
ACCEPT     all  --  anywhere             filesrv.informatik.haw-hamburg.de
ACCEPT     all  --  anywhere             ti-idm.informatik.haw-hamburg.de
ACCEPT     all  --  anywhere             192.168.0.0/16
ACCEPT     all  --  anywhere             172.16.1.0/24
ACCEPT     all  --  anywhere             anywhere
```
