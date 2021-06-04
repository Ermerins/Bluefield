#!/bin/bash

echo "Part 2"
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
