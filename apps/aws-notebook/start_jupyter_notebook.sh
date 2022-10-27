#!/bin/bash

ECS_INSTANCE_OUTPUT="/run/sandbox/fs/resources/aws-ecs-service/output"
ECS_INSTANCE_STATE="/run/sandbox/fs/resources/aws-ecs-service/state"
JUPYTER_KERNEL_DIR="/usr/local/share/jupyter/kernels/ECS IPython Kernel"
JUPYTER_KERNEL_FILE=$JUPYTER_KERNEL_DIR"/kernel.json"
SSH_PORT=22

function parse_ecs_instance() {
    local SSH_HOST=`jq .task_private_ip.value $ECS_INSTANCE_OUTPUT`
    if [ $? -eq 0 ] && [ ! -z "$SSH_HOST" ]; then
        echo "$SSH_HOST"
        return
    fi
    local SSH_HOST=`jq .task_private_ip.value $ECS_INSTANCE_STATE`
    if [ $? -eq 0 ] && [ ! -z "$SSH_HOST" ]; then
        echo "$SSH_HOST"
        return
    fi
    return    
}

function start_jupyter_notebook() {
    SSH_HOST=$(parse_ecs_instance)
    if [ -z "$SSH_HOST" ]; then
        echo "Can't parse ecs instance ip"
        sleep 5
        return
    fi
    SSH_HOST=`echo $SSH_HOST | sed 's/"//g'`
    echo "ECS Instance IP "$SSH_HOST":"$SSH_PORT

    # connect the ssh host and port 
    nc -w 5 $SSH_HOST $SSH_PORT
    if [ $? -ne 0 ]; then
        echo "Can't connect ${SSH_HOST}"
        return
    fi

    cat <<EOF | sudo tee "$JUPYTER_KERNEL_FILE"
    {
        "argv": [
            "/usr/bin/python3",
            "-m",
            "remote_ikernel",
            "--interface",
            "ssh",
            "--host",
            "root@$SSH_HOST -i ~/.ssh/aws-notebook_rsa",
            "--kernel_cmd",
            "ipython kernel -f {host_connection_file}",
            "{connection_file}"
        ],
        "display_name": "ECS IPython Kernel"
    }
EOF
    exec jupyter notebook --allow-root --no-browser --ip="*" --NotebookApp.token='' --NotebookApp.password=''
}

sudo mkdir -p "$JUPYTER_KERNEL_DIR"
if [ $? -ne 0 ]; then
    echo "Can't mkdir ${JUPYTER_KERNEL_DIR}"
    return
fi

for((i = 1; i <= 60; i++))
do
    start_jupyter_notebook
done

echo "Failed to start the jupyter-notebook"