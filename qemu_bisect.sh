#!/bin/bash

set -x
set -e

function register_binfmt() {
	local QEMU_PATH=$1

	echo -1 > /proc/sys/fs/binfmt_misc/qemu-aarch64
	echo ':qemu-aarch64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:'$QEMU_PATH'/bin/qemu-aarch64:F' > /proc/sys/fs/binfmt_misc/register

	echo -1 > /proc/sys/fs/binfmt_misc/qemu-arm
	echo ':qemu-arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:'$QEMU_PATH'/bin/qemu-arm:F' > /proc/sys/fs/binfmt_misc/register
}

function build_binfmt() {
	local QEMU_PATH=$1
	local COMMIT_ID=$2

	docker run -v$QEMU_PATH:/opt/qemu:rw --rm qemu_build $COMMIT_ID
}

function check_qemu() {
	if timeout -k 10m 10m docker run --platform=linux/arm -v /home/matwey/lab/linux:/usr/src/linux:ro -v /build:/build:ro -v /srv/tftpboot/:/boot:rw --rm matwey/opensuse-kernel-deploy:arm
	then
		exit 1
	else
		exit 0
	fi
}

QEMU_PATH=`mktemp -d`
COMMIT_ID=`git rev-parse BISECT_HEAD`
#COMMIT_ID=HEAD
#COMMIT_ID=opensuse-2.11

build_binfmt $QEMU_PATH $COMMIT_ID
register_binfmt $QEMU_PATH
check_qemu
