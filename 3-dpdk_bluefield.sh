#!/bin/bash

echo "Installing deps"
apt-get install libc6-dev libpcap0.8 libpcap0.8-dev libpcap-dev meson ninja-build

echo "Installing dpdk"
cd /home/ubuntu
wget https://fast.dpdk.org/rel/dpdk-20.11.1.tar.xz
tar -xJvf dpdk-20.11.1.tar.xz
cd dpdk-stable-20.11.1

export RTE_SDK=/home/ubuntu/dpdk-stable-20.11.1
export RTE_TARGET=arm64-armv8-linuxapp-gcc

cd /home/ubuntu
wget https://github.com/mesonbuild/meson/releases/download/0.58.0/meson-0.58.0.tar.gz
tar xzvf meson-0.58.0.tar.gz
cd meson-0.58.0
apt install -y python3-pip
pip3 install setuptools
python3 setup.py install
cd ../dpdk-stable-20.11.1
../meson-0.58.0/meson.py -Dexamples=all build
ninja -C build
ninja -C build install
