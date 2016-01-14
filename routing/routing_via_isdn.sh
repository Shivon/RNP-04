#!/bin/bash

echo "reset firewall settings"

sudo /sbin/rcSuSEfirewall2 restart

# shows current routing table: /sbin/route
# get routing: ip route show



echo "ban incoming ping from 172.16.1.0/24"

sudo /usr/sbin/iptables -I INPUT -p icmp --icmp-type echo-request -s 172.16.1.0/24 -j DROP

echo "ban outgoing pong to 172.16.1.0/24"

sudo /usr/sbin/iptables -I OUTPUT -p icmp --icmp-type echo-reply -d 172.16.1.0/24 -j DROP

echo "finished banning ping from 172.16.1.0/24"

# check for blocked ips: sudo /usr/sbin/iptables -L -vn