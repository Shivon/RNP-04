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
      * ISDN: 192.168.17.1 our port, 192.168.18.1 port of other subnet
      * Router: 192.168.17.2 our port, 192.168.18.2 port of other subnet AND 172.16.1.140 as port for both subnets
    * ethX = name of subnet
    * last part = our IP address in particular subnet

* __Task A__: route via ISDN only
* __Task B__: route via router only
