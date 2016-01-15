#!/bin/bash

echo "reset firewall settings"

sudo /sbin/rcSuSEfirewall2 restart

echo "delete route via isdn"

sudo /sbin/route del -host 192.168.17.14 gw 192.168.18.1 dev eth1

echo "ipv4: add router port for subnet of lab33"

sudo /sbin/route add -host 192.168.17.14 gw 192.168.18.2 dev eth1

echo "ipv6: add router port for subnet of lab33"

sudo /sbin/route add -A inet6 fd32:6de0:1f69:17::/64 gw fd32:6de0:1f69:18::2

echo "finished"