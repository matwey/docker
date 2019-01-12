#!/bin/bash

COMMITID=$1

set -e
set -x

pushd /usr/src/qemu
	git checkout $COMMITID
	./configure --target-list=arm-linux-user,aarch64-linux-user --static --prefix=/opt/qemu
	make -j 8
	make install
popd
