#!/bin/bash

IMPORT=$1
VERSION=$2
BASENAME=$(basename ${IMPORT})
DIRNAME=$(dirname ${IMPORT})

export PATH=~/go/bin:$PATH

go get github.com/kardianos/govendor
mkdir ~/go/src/${DIRNAME}
pushd ~/go/src/${DIRNAME}
git clone --depth 1 --branch v${VERSION} https://github.com/influxdata/influxdb.git ${BASENAME}-${VERSION}
pushd ${BASENAME}-${VERSION}
govendor migrate
govendor sync
popd
tar -Jcf /data/${BASENAME}-${VERSION}.tar.xz --exclude-vcs ${BASENAME}-${VERSION}
