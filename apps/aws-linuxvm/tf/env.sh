#!/bin/bash

# Inject the sandbox SSH public key to authorized_keys so the workspace is able to
# access the VM directly.
AUTHORIZED_KEYS="$(cs secret show -u default-ssh-0 -o json | jq -cMr .ssh_key.authorized_key)"$'\\n'

# TODO: find a way to figure out the right SSH public key for the
# current owner of the sandbox. E.g. infer from the email.
# In this example, the keypair matches "tag:OwnerEmail" with sandbox
# owner email will be injected into SSH authorized keys.
# The Terraform data source aws_key_pair can't be used because it requires
# exact match of one keypair.
AUTHORIZED_KEYS="${AUTHORIZED_KEYS}$(aws ec2 describe-key-pairs --include-public-key --filters "Name=tag:OwnerEmail,Values=$SANDBOX_OWNER_EMAIL" --query 'KeyPairs[*].[PublicKey]' --output text | while read; do echo -n "$REPLY\\n"; done)"

cat <<EOF
{
    "sandbox_id": "$SANDBOX_ID",
    "sandbox_name": "$SANDBOX_NAME",
    "authorized_keys": "$AUTHORIZED_KEYS"
}
EOF
