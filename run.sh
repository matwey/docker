#!/bin/bash

set -e
set -x

clickhouse-server --config-file=/etc/clickhouse-server/config.xml
