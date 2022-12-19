resource "aws_iam_role" "ecs" {
  name = "${var.deploy_name}-EcsTaskExec"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
        "Statement": [
        {
          "Sid": "",
          "Effect": "Allow",
          "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
        ]
    }
  EOF

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
}

resource "aws_ecs_cluster" "cluster" {
  name = var.deploy_name

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}
