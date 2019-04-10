#!/bin/bash

set -e
set -x

make -C /usr/src/atf DEBUG=0 V=1 DISABLE_PEDANTIC=1 PLAT=rk3328 all

make -C /usr/src/u-boot rk3328_defconfig
echo CONFIG_EFI_LOADER=y >> /build/.config
echo CONFIG_CMD_BOOTEFI=y >> /build/.config
make -C /usr/src/u-boot oldconfig

install -D -m 0644 /usr/src/atf/build/rk3328/release/bl31/bl31.elf ${KBUILD_OUTPUT}/bl31.elf

make -C /usr/src/u-boot PLATFORM_LIBGCC=/usr/local/lib/libgcc.a all
make -C /usr/src/u-boot PLATFORM_LIBGCC=/usr/local/lib/libgcc.a u-boot.itb

#${KBUILD_OUTPUT}/tools/mkimage -n rk3328 -T rksd -d ${KBUILD_OUTPUT}/tpl/u-boot-tpl.bin /boot/idbloader.img
${KBUILD_OUTPUT}/tools/mkimage -n rk3328 -T rksd -d /usr/src/rkbin/bin/rk33/rk3328_ddr_333MHz_v1.14.bin /boot/idbloader.img
cat ${KBUILD_OUTPUT}/spl/u-boot-spl.bin >> /boot/idbloader.img
install -D -m 0644 ${KBUILD_OUTPUT}/u-boot.itb /boot/u-boot.itb
