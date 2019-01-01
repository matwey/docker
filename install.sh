#!/bin/bash

set -e
set -x

zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution bc cross-aarch64-gcc7 cross-arm-none-gcc7 cross-arm-none-newlib-devel gcc git gzip libopenssl-devel make patch tar which
zypper -n clean -a
