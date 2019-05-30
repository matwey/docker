#!/bin/bash

set -e
set -x

zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution bc bison cross-aarch64-gcc7 cross-arm-none-gcc7 cross-arm-none-newlib-devel flex gcc gcc-c++ git gzip dtc libopenssl-devel libuuid-devel make nasm patch python python-devel python-pip swig tar which
zypper -n clean -a

pip install pyelftools

pushd /usr/src
git config --global user.email "matwey.kornilov@gmail.com"
#git clone --branch next-dev https://github.com/rockchip-linux/u-boot.git u-boot
git clone --branch rock64_v3 https://github.com/matwey/u-boot.git u-boot
git clone --depth 1 --branch v1.6 https://github.com/ARM-software/arm-trusted-firmware.git atf
git clone --depth 1 https://github.com/rockchip-linux/rkbin.git rkbin
popd
