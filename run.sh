#!/bin/bash

set -e
set -x

make -C /usr/src/linux modules_install

case "$(uname -m)" in
	armv*)
		make -C /usr/src/linux dtbs_install
		make -C /usr/src/linux zinstall
		install -m 0755 /usr/local/lib/grub.efi /boot/bootarm.efi
	;;
	aarch64)
		make -C /usr/src/linux dtbs_install
		make -C /usr/src/linux install
		install -m 0755 /usr/local/lib64/grub.efi /boot/bootaa64.efi
	;;
	*)
		make -C /usr/src/linux install
		install -m 0755 /usr/lib64/efi/shim.efi /boot/bootx64.efi
		install -m 0755 /usr/local/lib64/grub.efi /boot/grub.efi
		install -m 0755 /usr/local/lib/grub.pxe /boot/pxelinux.0
	;;
esac