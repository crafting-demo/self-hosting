terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4"
    }
  }
}

data "external" "env" {
  program = ["${path.module}/env.sh"]
}

provider "aws" {
  default_tags {
    tags = {
      Sandbox = data.external.env.result.sandbox_name
    }
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_instance" "vm" {
  launch_template {
    name = var.launch_template_name
  }
  instance_type = var.instance_type == "" ? null : var.instance_type
  key_name      = var.key_name == "" ? null : var.key_name
  root_block_device {
    volume_size = var.root_volume_size
  }
}
