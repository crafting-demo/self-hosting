variable "ecs_cluster_name" {
  description = "The name of ECS cluster."
  type        = string
}

variable "ecs_task_exec_role_arn" {
  description = "The Role ARN for executing ECS tasks."
  type        = string
}

variable "ecs_task_image" {
  description = "The container image used for ECS tasks."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet ids for running ECS tasks."
  type        = list(string)
  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "At least one subnet ID must be provided."
  }
}

variable "security_group_ids" {
  description = "The additional security groups to attach to the ECS tasks."
  type        = list(string)
  default     = []
}

variable "service_launch_type" {
  type    = string
  default = "FARGATE"
}
