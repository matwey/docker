#!/bin/bash

set -e
set -x

zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution btrfsprogs gcc iproute2 iputils hostname kmod kmod-compat libelf-devel make wicked

zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution shim grub2-i386-pc grub2-x86_64-efi
grub2-mkimage -O i386-pc-pxe -o /usr/local/lib/grub.pxe --prefix= echo http linux net normal pxe pxechain serial tftp
grub2-mkimage -O x86_64-efi -o /usr/local/lib64/grub.efi --prefix= echo efi_gop efi_uga efinet http linux linuxefi net normal serial tftp

zypper -n clean -a
