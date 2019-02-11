#!/bin/bash

set -e
set -x

zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution bc cross-aarch64-gcc7 cross-arm-none-gcc7 cross-arm-none-newlib-devel gcc gcc-c++ git gzip libopenssl-devel libuuid-devel make nasm patch python tar which
zypper -n clean -a

pushd /usr/src
git clone --depth 1 --branch atf-v1.5-armada-18.12 https://github.com/MarvellEmbeddedProcessors/atf-marvell.git atf
git clone --depth 1 --branch u-boot-2018.03-armada-18.12 https://github.com/MarvellEmbeddedProcessors/u-boot-marvell.git u-boot
git clone --depth 1 --branch mv_ddr-armada-18.12 https://github.com/MarvellEmbeddedProcessors/mv-ddr-marvell.git mv-ddr
git clone --depth 1 --branch A3700_utils-armada-18.12 https://github.com/MarvellEmbeddedProcessors/A3700-utils-marvell.git A3700-utils
git clone --depth 1 --branch uefi-espressobin https://github.com/matwey/uefi-marvell.git edk2
popd
