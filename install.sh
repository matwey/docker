#!/bin/bash

set -e
set -x

zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution coreutils git

zypper -n clean -a

pushd /usr/src
git clone --depth 1 https://github.com/rockchip-linux/rkbin.git rkbin
popd
