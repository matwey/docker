#!/bin/bash

set -e
set -x

zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution git gcc8-c++ ninja cmake

pushd /usr/src

git clone --recursive --branch 19.17 https://github.com/ClickHouse/ClickHouse.git
cd ClickHouse
mkdir build

pushd build
export CC=gcc-8
export CXX=g++-8
cmake .. -DCMAKE_BUILD_TYPE=Release
ninja
ninja install
popd

popd

rm -rf /usr/src
zypper -n clean -a
