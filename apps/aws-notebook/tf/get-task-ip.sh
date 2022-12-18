#!/bin/bash
set -e
set -o pipefail

AWS_REGION="$(aws configure get region)"

eval "$(jq -r '@sh "ECS_CLUSTER_NAME=\(.ecs_cluster_name) ECS_SERVICE_NAME=\(.ecs_service_name)"')"

function get_task_ip(){
  local task_arn
  task_arn="$(aws ecs list-tasks --region ${AWS_REGION} --cluster ${ECS_CLUSTER_NAME} --service=${ECS_SERVICE_NAME} | jq -cMr .taskArns[0])"
  echo "$(aws ecs describe-tasks --tasks ${task_arn} --region ${AWS_REGION} --cluster ${ECS_CLUSTER_NAME} | jq -cMr '.tasks[0].attachments[0].details[] | select(.name==\"privateIPv4Address\") | .value')"
}

function get_stable_task_ip(){
  local task_ip final_ip count=0
  while true; do
    task_ip="$(get_task_ip)"
    if [[ -z "$final_ip" ]]; then
      final_ip="$task_ip"
    elif [[ "$task_ip" == "$final_ip" ]]; then
      count=$((count+1))
      [[ $count -lt 3 ]] || break
    else
      final_ip="$task_ip"
      count=0
    fi
    sleep 2
  done
  echo "task_ip"
}

cat <<EOF
{"private_ip": "$(get_stable_task_ip)"}
EOF
