#!/bin/bash

set -e
set -x

if [[ -f "/build/tpl/u-boot-tpl.bin" ]]
then
	TPL_BINARY="/build/tpl/u-boot-tpl.bin"
else
	TPL_BINARY="/usr/src/rkbin/bin/rk33/rk3328_ddr_333MHz_v1.16.bin"
fi
${KBUILD_OUTPUT}/tools/mkimage -n rk3328 -T rksd -d ${TPL_BINARY} /boot/idbloader.img
cat ${KBUILD_OUTPUT}/spl/u-boot-spl.bin >> /boot/idbloader.img
install -D -m 0644 ${KBUILD_OUTPUT}/u-boot.itb /boot/u-boot.itb

dd if=/boot/idbloader.img of=/dev/mmcblk0 seek=64 conv=notrunc
dd if=/boot/u-boot.itb of=/dev/mmcblk0 seek=16384 conv=notrunc
