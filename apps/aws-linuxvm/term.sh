#!/bin/bash

. "${BASH_SOURCE[0]%/*}/functions.sh"

wait_for_state
exec ssh -o StrictHostKeyChecking=no "$(state_value user)@$(state_value private_ip)" "$@"
