#!/bin/bash

set -e
set -x

make -C /usr/src/linux modules_install
make -C /usr/src/linux install
install -m 0755 /usr/local/lib64/grub.efi /boot/bootaa64.efi
