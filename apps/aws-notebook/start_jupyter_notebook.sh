#!/bin/bash

ECS_INSTANCE_STATE="/run/sandbox/fs/resources/aws-ecs-service/test"
JUPYTER_KERNEL_DIR="/usr/local/share/jupyter/kernels/ECS IPython Kernel"
JUPYTER_KERNEL_FILE=$JUPYTER_KERNEL_DIR"/kernel.json"
IP_PORT=22

function fatal() {
  echo "$@" >&2
  exit 1
}

function ecs_ip() {
    local ip_addr
    ip_addr=`jq .task_private_ip.value $ECS_INSTANCE_STATE`
    if [ $? -eq 0 ] && [ ! -z "$ip_addr" ]; then
        ip_addr=`echo $ip_addr | sed 's/"//g'`
        echo "$ip_addr"
    fi
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

sudo mkdir -p "$JUPYTER_KERNEL_DIR"

IP_ADDR="$(wait_for_ecs_ip)"
[ ! -z "$IP_ADDR" ] || fatal "Wait for ECS IP timed out."

nc -w 5 $IP_ADDR $IP_PORT
[ $? -eq 0 ] || fatal "Can't connect ${IP_ADDR}"

cat <<EOF | sudo tee "$JUPYTER_KERNEL_FILE"
{
    "argv": [
        "/usr/bin/python3",
        "-m",
        "remote_ikernel",
        "--interface",
        "ssh",
        "--host",
        "root@$IP_ADDR:$IP_PORT -i ~/.ssh/aws-notebook_rsa",
        "--kernel_cmd",
        "ipython kernel -f {host_connection_file}",
        "{connection_file}"
    ],
    "display_name": "ECS IPython Kernel"
}
EOF

exec jupyter notebook --allow-root --no-browser --ip="*" --NotebookApp.token='' --NotebookApp.password=''
