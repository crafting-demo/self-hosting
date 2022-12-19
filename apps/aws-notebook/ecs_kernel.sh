#!/bin/bash

set -ex
BASE="$(readlink -nf ${BASH_SOURCE[0]%/*})"
TARGET_ADDR=$("$BASE/ecs_target.sh")

HOST_CONN_FILE="$1"
CONN_FILE="$2"

exec /usr/bin/python3 -m remote_ikernel --interface ssh --host "root@$TARGET_ADDR:22 -i ~/.ssh/aws-notebook_rsa" \
    --kernel_cmd "ipython kernel -f $HOST_CONN_FILE" \
    "$CONN_FILE"
