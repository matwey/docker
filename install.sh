#!/bin/bash

set -e
set -x

zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution btrfsprogs gcc dracut iproute2 iputils hostname kmod kmod-compat libelf-devel make openssh wicked systemd-network

case "$(uname -m)" in
	armv*)
		zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution grub2-arm-efi

		grub2-mkimage -O arm-efi -o /usr/local/lib/grub.efi --prefix= echo efi_gop efinet http linux net normal serial tftp
	;;
	aarch64)
		zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution grub2-arm64-efi

		grub2-mkimage -O arm64-efi -o /usr/local/lib64/grub.efi --prefix= echo efi_gop efinet http linux net normal serial tftp
	;;
	*)
		zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution shim grub2-i386-pc grub2-x86_64-efi

		grub2-mkimage -O i386-pc-pxe -o /usr/local/lib/grub.pxe --prefix= echo http linux net normal pxe pxechain serial tftp
		grub2-mkimage -O x86_64-efi -o /usr/local/lib64/grub.efi --prefix= echo efi_gop efi_uga efinet http linux linuxefi net normal serial tftp
	;;
esac

zypper -n clean -a
