#!/bin/bash

echo "Downloading stuff..."
wget https://www.mellanox.com/downloads/ofed/MLNX_OFED-5.3-1.0.0.1/MLNX_OFED_LINUX-5.3-1.0.0.1-ubuntu18.04-x86_64.iso
wget http://www.mellanox.com/downloads/BlueField/BFBs/Ubuntu18.04/Ubuntu18.04.3-MLNX_OFED_LINUX-UPSTREAM-LIBS-5.0-2.1.8.0.1-aarch64.bfb
git clone https://github.com/Mellanox/rshim.git

echo "Installing other stuff..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install linux-signed-generic-hwe-18.04
sudo reboot --force
