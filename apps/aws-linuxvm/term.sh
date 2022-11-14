#!/bin/bash

TFDIR="$(readlink -nf ${BASH_SOURCE[0]%/*})/tf"

exec ssh -o StrictHostKeyChecking=no -i "$SSH_KEYPAIR_FILE" \
    $(terraform -chdir="$TFDIR" output -raw user)@$(terraform -chdir="$TFDIR" output -raw private_ip) "$@"
