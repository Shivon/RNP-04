### Part 2
* __Task__: get server from RNP-02/03 running on port 9400
* __Result__: not possible because another process is listening on it (PID 1972 / Program name rn10server)

### Part 3

### Part 4

* __Gerenal helpful stuff__:
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


* __Task B__: route via router only
