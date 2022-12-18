#!/bin/bash

ECS_INSTANCE_STATE="/run/sandbox/fs/resources/ecs/state"
JUPYTER_KERNEL_DIR="/usr/local/share/jupyter/kernels/ECS IPython Kernel"
JUPYTER_KERNEL_FILE="$JUPYTER_KERNEL_DIR/kernel.json"
SSH_PORT=22

function fatal() {
  echo "$@" >&2
  exit 1
}

function ecs_ip() {
    local ip_addr="$(jq -cMr .task_private_ip.value $ECS_INSTANCE_STATE 2>/dev/null || true)"
    [[ "$ip_addr" == "null" ]] || echo "$ip_addr"
}

function wait_for_ecs_ip() {
    local ip_addr
    for ((i=0; i<600; i=i+1)); do
        ip_addr="$(ecs_ip)"
        [[ -z "$ip_addr" ]] || break
        sleep 1
    done
    echo "$ip_addr"
}

SSH_HOST="$(wait_for_ecs_ip)"
[[ -n "$SSH_HOST" ]] || fatal "Wait for ECS IP timed out."

nc -vz -w 5 "$SSH_HOST" $SSH_PORT || fatal "Can't connect ${SSH_HOST}"

sudo mkdir -p "$JUPYTER_KERNEL_DIR"

cat <<EOF | sudo tee "$JUPYTER_KERNEL_FILE"
{
    "argv": [
        "/usr/bin/python3",
        "-m",
        "remote_ikernel",
        "--interface",
        "ssh",
        "--host",
        "root@$SSH_HOST:$SSH_PORT -i ~/.ssh/aws-notebook_rsa",
        "--kernel_cmd",
        "ipython kernel -f {host_connection_file}",
        "{connection_file}"
    ],
    "display_name": "ECS IPython Kernel"
}
EOF

exec jupyter notebook --no-browser --ip="*" --NotebookApp.token='' --NotebookApp.password=''
