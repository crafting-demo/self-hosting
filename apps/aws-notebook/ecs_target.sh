#!/bin/bash

STATE_FILE="/run/sandbox/fs/resources/ecs/state"

function fatal() {
  echo "$@" >&2
  exit 1
}

[[ -f "$STATE_FILE" ]] || fatal "ECS resources not ready. Please wait!"

function ecs_ip() {
  local cluster_name service_name task_arn addr
  cluster_name="$(jq -cMr .ecs_cluster_name.value <$STATE_FILE)"
  service_name="$(jq -cMr .ecs_service_name.value <$STATE_FILE)"
  [[ -n "$cluster_name" && "$cluster_name" != "null" && \
     -n "$service_name" && "$service_name" != "null" ]] || return
  task_arn="$(aws ecs list-tasks --cluster $cluster_name --service=$service_name | jq -cMr .taskArns[0])"
  [[ -n "$task_arn" && "$task_arn" != "null" ]] || return
  addr="$(aws ecs describe-tasks --tasks $task_arn --cluster $cluster_name | jq -cMr '.tasks[0].attachments[0].details[]|select(.name=="privateIPv4Address")|.value')"
  [[ -z "$addr" || "$addr" == "null" ]] || echo "$addr"
}

TARGET_ADDR="$(ecs_ip)"

[[ -n "$TARGET_ADDR" ]] || fatal "ECS task address unavailable, please try again later!"

echo "$TARGET_ADDR"
