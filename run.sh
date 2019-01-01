#!/bin/bash

set -e
set -x

export BL33=/build/u-boot.bin
export MV_DDR_PATH=/usr/src/mv-ddr

pushd /usr/src
git clone --depth 1 --branch atf-v1.5-armada-18.12 https://github.com/MarvellEmbeddedProcessors/atf-marvell.git atf
git clone --depth 1 --branch u-boot-2018.03-armada-18.12 https://github.com/MarvellEmbeddedProcessors/u-boot-marvell.git u-boot
git clone --depth 1 --branch mv_ddr-armada-18.12 https://github.com/MarvellEmbeddedProcessors/mv-ddr-marvell.git mv-ddr
git clone --depth 1 --branch A3700_utils-armada-18.12 https://github.com/MarvellEmbeddedProcessors/A3700-utils-marvell.git A3700-utils
popd

make -C /usr/src/u-boot mvebu_espressobin-88f3720_defconfig
make -C /usr/src/u-boot DEVICE_TREE=armada-3720-espressobin PLATFORM_LIBGCC=/usr/local/lib/libgcc.a
make -C /usr/src/atf DEBUG=1 USE_COHERENT_MEM=0 LOG_LEVEL=20 SECURE=0 CLOCKSPRESET=CPU_1000_DDR_800 DDR_TOPOLOGY=2 BOOTDEV=SATA PARTNUM=0 WTP=/usr/src/A3700-utils PLAT=a3700 all fip

install -m 0644 /usr/src/atf/build/a3700/debug/flash-image.bin /boot/flash-image.bin
