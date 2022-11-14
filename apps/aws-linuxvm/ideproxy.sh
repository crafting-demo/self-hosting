#!/bin/bash

set -ex

. "${BASH_SOURCE[0]%/*}/functions.sh"

wait_for_state
exec socat TCP-LISTEN:$1,fork,reuseaddr TCP-CONNECT:$(state_value private_ip):$(state_value vscode_server_port)
