#!/bin/bash

echo "reset firewall settings"

sudo /sbin/rcSuSEfirewall2 restart

echo "ban tcp input from 172.16.1.0/24"

sudo /usr/sbin/iptables -I INPUT -p TCP -d 172.16.1.0/24 -j DROP

echo "ban tcp output for 172.16.1.0/24"

sudo /usr/sbin/iptables -I OUTPUT -p TCP -s 172.16.1.0/24 -j DROP

echo "finished banning tcp connections within 172.16.1.0/24"

# check for blocked ips: sudo /usr/sbin/iptables -L -vn