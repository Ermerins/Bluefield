#!/bin/bash

echo "You should be running this on the bluefield"
echo "Adding google nameserver"
sudo echo nameserver 8.8.8.8 > /etc/resolv.conf

echo "Updating"
sudo apt update -y && sudo apt upgrade -y

echo "Adding cables"
mst start
mst status -v
mst cable add
sudo mlxcables

echo "Checking mode"
mlxconfig -d /dev/mst/mt41682_pciconf0 q | grep -i internal_cpu_model


