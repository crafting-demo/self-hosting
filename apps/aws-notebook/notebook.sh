#!/bin/bash

set -ex
BASE="$(readlink -nf ${BASH_SOURCE[0]%/*})"

JUPYTER_KERNEL_FILE="$HOME/.local/share/jupyter/kernels/ecs/kernel.json"

mkdir -p "$(dirname "$JUPYTER_KERNEL_FILE")"
cat <<EOF >"$JUPYTER_KERNEL_FILE"
{
    "argv": ["$BASE/ecs_kernel.sh", "{host_connection_file}", "{connection_file}"],
    "display_name": "ECS Cluster"
}
EOF
exec jupyter notebook --no-browser --ip="*" --NotebookApp.token='' --NotebookApp.password=''
