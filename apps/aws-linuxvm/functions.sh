STATE_FILE="/run/sandbox/fs/resources/linux/state"

function state_value() {
    local value="$(jq -cMr ".${1}.value" <"$STATE_FILE" 2>/dev/null || true)"
    [[ -z "$value" || "$value" == "null" ]] || echo "$value"
}

function wait_for_state() {
    while [[ -z "$(state_value private_ip)" ]]; do sleep 1; done
}
