#!/bin/bash

# TODO: find a way to figure out the right SSH public key for the
# current owner of the sandbox. E.g. infer from the email.
# In this example, the keypair matches "tag:OwnerEmail" with sandbox
# owner email will be injected into SSH authorized keys.
# The Terraform data source aws_key_pair can't be used because it requires
# exact match of one keypair.
AUTHORIZED_KEYS="$(aws ec2 describe-key-pairs --include-public-key --filters "Name=tag:OwnerEmail,Values=$SANDBOX_OWNER_EMAIL" --query 'KeyPairs[*].[PublicKey]' --output text | while read; do echo -n "$REPLY\\n"; done)"

cat <<EOF
{
    "sandbox_id": "$SANDBOX_ID",
    "sandbox_name": "$SANDBOX_NAME",
    "authorized_keys": "$AUTHORIZED_KEYS",
    "ssh_keypair_file": "$SSH_KEYPAIR_FILE"
}
EOF
