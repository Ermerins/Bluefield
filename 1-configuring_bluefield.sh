#!/bin/bash

echo "Downloading stuff..."
wget https://www.mellanox.com/downloads/ofed/MLNX_OFED-5.3-1.0.0.1/MLNX_OFED_LINUX-5.3-1.0.0.1-ubuntu18.04-x86_64.iso
wget http://www.mellanox.com/downloads/BlueField/BFBs/Ubuntu18.04/Ubuntu18.04.3-MLNX_OFED_LINUX-UPSTREAM-LIBS-5.0-2.1.8.0.1-aarch64.bfb
git clone https://github.com/Mellanox/rshim.git

echo "Installing other stuff..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install linux-signed-generic-hwe-18.04
sudo apt install build-essential debhelper autotools-dev dkms

mount MLNX_OFED_LINUX-5.3-1.0.0.1-ubuntu18.04-x86_64.iso /mnt
sudo /mnt/uninstall.sh --force
sudo /mnt/mlnxofedinstall --add-kernel-support
sudo mlxfwmanager
/etc/init.d/openibd restart

echo "Rshim time..."
cd rshim
make -C /lib/modules/`uname -r`/build M=$PWD
make -C /lib/modules/`uname -r`/build M=$PWD INSTALL_MOD_DIR=extra/rshim modules_install
dpkg-buildpackage -us -uc -nc
sudo dpkg -i ../rshim-dkms_*.deb
sudo modprobe -vr rshim_usb
sudo modprobe -vr rshim_net
sudo modprobe -vr rshim_pcie

sudo modprobe rshim_usb
sudo modprobe rshim_net

echo 'SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="00:1a:ca:ff:ff:02", ATTR{type}=="1", NAME="tmfifo_net0", RUN+="/usr/sbin/ifup tmfifo_net0"' >> /etc/udev/rules.d/91-tmfifo_net.rules

ifconfig tmfifo_net0 192.168.100.1/24 up
ifconfig enp1s0f0 192.168.0.20 up
ifconfig enp1s0f1 192.168.0.21 up

echo "Install the image to the bluefield..."
cat Ubuntu18.04.3-MLNX_OFED_LINUX-UPSTREAM-LIBS-5.0-2.1.8.0.1-aarch64.bfb > /dev/rshim0/boot

sudo systemctl enable rshim
sudo systemctl start rshim

echo "Now you can try to ssh into the bluefield with ssh ubuntu@192.168.100.2"
echo "You might want to reboot"
