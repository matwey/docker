#!/bin/bash

set -e
set -x

zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution bc cross-aarch64-gcc7 cross-arm-none-gcc7 cross-arm-none-newlib-devel gcc gcc-c++ git gzip dtc libopenssl-devel libuuid-devel make nasm patch python python-devel python-pip swig tar which
zypper -n clean -a

pip install pyelftools

pushd /usr/src
git config --global user.email "matwey.kornilov@gmail.com"
git clone --branch next-dev https://github.com/rockchip-linux/u-boot.git u-boot
git --git-dir=$PWD/u-boot/.git remote add opensuse https://github.com/openSUSE/u-boot.git
git --git-dir=$PWD/u-boot/.git fetch opensuse master
git --git-dir=$PWD/u-boot/.git fetch opensuse tumbleweed
git --git-dir=$PWD/u-boot/.git cherry-pick -x a8606ef0757b722e33c98858c0e4cc6a07b41867 \
	c80214ce1f39a9b9da32dbe941ff83051b03c080 \
	a80a232e965acc08d5323b2acc55da855adcf4f3 \
	9309a1b76ce4f18fe1d9fe48f2b1356ebc58b62f \
	adae4313cdd891e5ab76c407134b69bd825220e4 \
	884bcf6f65c414dce3b3d2a91e2c9eba0e5e08f8 \
	77511b3b4be449f1547cd97ec6dde780ef589d84 \
	b66c60dde9d48889b93694326d40f7e5208cff25 \
	257d552be83fd5507780e1f4c09545aab9ea7689
git clone --depth 1 --branch v1.6 https://github.com/ARM-software/arm-trusted-firmware.git atf
git clone --depth 1 https://github.com/rockchip-linux/rkbin.git rkbin
popd
