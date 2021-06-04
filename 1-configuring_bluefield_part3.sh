#!/bin/bash

echo "Part 3"
ifconfig tmfifo_net0 192.168.100.1/24 up
ifconfig enp1s0f0 192.168.0.20 up
ifconfig enp1s0f1 192.168.0.21 up

echo "Install the image to the bluefield..."
cat Ubuntu18.04.3-MLNX_OFED_LINUX-UPSTREAM-LIBS-5.0-2.1.8.0.1-aarch64.bfb > /dev/rshim0/boot

sudo systemctl enable rshim
sudo systemctl start rshim

echo "Now you can try to ssh into the bluefield with ssh ubuntu@192.168.100.2"
