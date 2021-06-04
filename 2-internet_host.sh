#!/bin/bash

echo "You should be running this on the host BEFORE running the internet bluefield script"
echo "Enabling forwarding and adding iptables..."
echo "1" > /proc/sys/net/ipv4/ip_forward
iptables -A INPUT -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
iptables --append FORWARD --in-interface tmfifo_net0 -j ACCEPT
iptables -A OUTPUT -j ACCEPT
iptables -A FORWARD -i eth0 -o tmfifo_net0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
echo "Done" 
