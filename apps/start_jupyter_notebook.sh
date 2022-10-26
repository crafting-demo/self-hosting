ECS_INSTANCE_FILE="/run/sandbox/fs/resources/aws-ecs-service/output"
JUPYTER_KERNEL_DIR="/usr/local/share/jupyter/kernels/ECS IPython Kernel"
JUPYTER_KERNEL_FILE=$JUPYTER_KERNEL_DIR"/kernel.json"

function start_jupyter_notebook() {
    SSH_PORT=22
    # parse the ecs instance ip
    SSH_HOST=`jq .task_private_ip.value $ECS_INSTANCE_FILE`
    if [ $? -ne 0 ]; then
        echo "Can't parse ecs instance ip"
        sleep 5
        return
    fi
    SSH_HOST=`echo $SSH_HOST | sed 's/"//g'`

    # netcat the ssh host and port 
    nc -w 5 $SSH_HOST $SSH_PORT
    if [ $? -ne 0 ]; then
        echo "Can't connect ${SSH_HOST}"
        return
    fi

    echo "{
        \"argv\": [
            \"/usr/bin/python3\",
            \"-m\",
            \"remote_ikernel\",
            \"--interface\",
            \"ssh\",
            \"--host\",
            \"root@$SSH_HOST -i ~/.ssh/aws-notebook_rsa\",
            \"--kernel_cmd\",
            \"ipython kernel -f {host_connection_file}\",
            \"{connection_file}\"
        ],
        \"display_name\": \"ECS IPython Kernel\"
    }" | sudo tee "$JUPYTER_KERNEL_FILE"

    jupyter notebook --allow-root --no-browser --ip 0.0.0.0 &
    echo "Jupyter notebook is started"
    exit 0
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