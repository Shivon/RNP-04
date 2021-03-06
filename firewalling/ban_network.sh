#!/bin/bash

echo "reset firewall settings"

sudo /sbin/rcSuSEfirewall2 restart

echo "ban input from 172.16.1.0/24"

sudo /usr/sbin/iptables -I INPUT -d 172.16.1.0/24 -j DROP

echo "ban output for 172.16.1.0/24"

sudo /usr/sbin/iptables -I OUTPUT -s 172.16.1.0/24 -j DROP

echo "finished banning 172.16.1.0/24"

# check for blocked ips: sudo /usr/sbin/iptables -L -vn