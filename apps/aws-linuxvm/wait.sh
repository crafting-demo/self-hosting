#!/bin/bash

TFDIR="$(readlink -nf ${BASH_SOURCE[0]%/*})/tf"

while [[ -z "$(terraform -chrdir=$TFDIR output -raw private_ip 2>/dev/null || true)" ]]; do
    sleep 1
done
