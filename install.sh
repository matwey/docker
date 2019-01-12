#!/bin/bash

set -e
set -x

zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution gcc qemu git make glib2-devel-static glibc-devel-static zlib-devel-static python python3 pcre-devel-static libpixman-1-0-devel flex bison
zypper -n clean -a

pushd /usr/src
git clone https://github.com/openSUSE/qemu.git qemu
popd
