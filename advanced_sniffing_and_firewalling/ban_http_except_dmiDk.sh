#!/bin/bash

echo "reset firewall settings"

sudo /sbin/rcSuSEfirewall2 restart

echo "ban outgoing http requests"

sudo /usr/sbin/iptables -I OUTPUT -p tcp --dport 80 -j REJECT --reject-with tcp-reset

echo "add exception for dmi.dk"

sudo /usr/sbin/iptables -I OUTPUT -d www.dmi.dk -p tcp --dport 80 -j ACCEPT

echo "finished"

# check for blocked ips: sudo /usr/sbin/iptables -L -vn