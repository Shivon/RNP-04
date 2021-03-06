#!/bin/bash

echo "reset firewall settings"

sudo /sbin/rcSuSEfirewall2 restart

echo "ban input from 172.16.1.0/24"

sudo /usr/sbin/iptables -I INPUT -d 172.16.1.0/24 -j DROP

echo "ban output for 172.16.1.0/24"

sudo /usr/sbin/iptables -I OUTPUT -s 172.16.1.0/24 -j DROP

echo "finished banning 172.16.1.0/24"

echo "enable input from tcp server for port 51000"

sudo /usr/sbin/iptables -I INPUT -p TCP --dport 51000 -d 172.16.1.0/24 -j ACCEPT

echo "enable output for tcp server on port 51000"

sudo /usr/sbin/iptables -I OUTPUT -p TCP --sport 51000 -s 172.16.1.0/24 -j ACCEPT

echo "finished enabling TCP via port 51000"

# check for blocked ips: sudo /usr/sbin/iptables -L -vn