#!/bin/bash

InterfazDeseada=eth0
IPDeseada=192.168.0.1

echo ""
echo "Capturando el tráfico telnet de la IP $IPDeseada..."echo ""

touch /root/telnet.pcap
truncate -s 0 /root/telnet.pcap
tshark -P -i $InterfazDeseada -f "tcp port 23 and host $IPDeseada" -w /root/telnet.pcap

