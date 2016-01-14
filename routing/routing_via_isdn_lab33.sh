#!/bin/bash

echo "reset firewall settings"

sudo /sbin/rcSuSEfirewall2 restart

echo "add ISDN port for subnet of lab33"

sudo /sbin/route add -host 192.168.17.14 gw 192.168.18.1 dev eth1

echo "finished"