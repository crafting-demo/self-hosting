#!/bin/bash

[[ -f ~/.ssh/aws-notebook_rsa && -f ~/.ssh/aws-notebook_rsa.pub ]] || {
  rm -f ~/.ssh/aws-notebook_rsa ~/.ssh/aws-notebook_rsa.pub
  ssh-keygen -t rsa -N "" -f ~/.ssh/aws-notebook_rsa >&2
}

cat <<EOF
{
  "sandbox_id": "$SANDBOX_ID",
  "sandbox_name": "$SANDBOX_NAME",
  "ssh_public_key": "$(cat ~/.ssh/aws-notebook_rsa.pub)"
}
EOF
