#!/bin/bash

set -e
set -x

FIRMWARE=$1

if [ "x$FIRMWARE" == "xtianocore" ] ; then
	export BL33=/Build/Armada37x0Db-AARCH64/RELEASE_GCC5/FV/ARMADA_EFI.fd
else
	export BL33=/build/u-boot.bin
fi

export MV_DDR_PATH=/usr/src/mv-ddr
export GCC5_AARCH64_PREFIX=aarch64-suse-linux-
export PACKAGES_PATH=/usr/src/edk2:/usr/src/edk2/edk2-platforms
export EDK_TOOLS_PATH=/usr/src/edk2/BaseTools

if [ "x$FIRMWARE" == "xtianocore" ] ; then
	set --
	source /usr/src/edk2/edksetup.sh
	make -C /usr/src/edk2/BaseTools
	build -b RELEASE -a AARCH64 -t GCC5 -p Platform/Marvell/Armada37x0Db/Armada37x0Db.dsc
else
	make -C /usr/src/u-boot mvebu_espressobin-88f3720_defconfig
	make -C /usr/src/u-boot DEVICE_TREE=armada-3720-espressobin PLATFORM_LIBGCC=/usr/local/lib/libgcc.a
fi

make -C /usr/src/atf DEBUG=0 USE_COHERENT_MEM=0 LOG_LEVEL=20 SECURE=0 CLOCKSPRESET=CPU_1000_DDR_800 DDR_TOPOLOGY=2 BOOTDEV=SATA PARTNUM=0 WTP=/usr/src/A3700-utils PLAT=a3700 all fip

pushd /usr/src/atf/build/a3700/release
install -m 0644 flash-image.bin /boot/flash-image.bin
install -m 0644 uart-images.tgz /boot/uart-images.tgz
popd
