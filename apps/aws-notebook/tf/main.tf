terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Sandbox = data.external.env.result.sandbox_name
    }
  }
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = var.ecs_cluster_name
}

data "external" "env" {
  program = ["${path.module}/env.sh"]
}

resource "aws_ecs_task_definition" "notebook" {
  family                   = "notebook_${data.external.env.result.sandbox_id}"
  requires_compatibilities = ["FARGATE", "EC2"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  task_role_arn      = var.ecs_task_exec_role_arn
  execution_role_arn = var.ecs_task_exec_role_arn
  container_definitions = jsonencode([
    {
      name      = "notebook"
      image     = var.ecs_task_image
      essential = true
      environment = [
        {
          name  = "PUBLIC_KEY"
          value = data.external.env.result.ssh_public_key
        }
      ]
      portMappings = [
        {
          containerPort = 22
          hostPort      = 22
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "notebook" {
  launch_type         = var.service_launch_type
  task_definition     = aws_ecs_task_definition.notebook.arn
  name                = "notebook_${data.external.env.result.sandbox_id}"
  cluster             = data.aws_ecs_cluster.cluster.id
  scheduling_strategy = "REPLICA"
  desired_count       = 1
  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = false
    security_groups  = var.security_group_ids
  }
}
