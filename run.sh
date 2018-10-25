#!/bin/bash

set -e
set -x

make -C /usr/src/linux modules_install
make -C /usr/src/linux install
install -m 0755 /usr/lib64/efi/shim.efi /boot/bootx64.efi
install -m 0755 /usr/local/lib64/grub.efi /boot/grub.efi
install -m 0755 /usr/local/lib/grub.pxe /boot/pxelinux.0
