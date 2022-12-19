module "aws" {
  source      = "./aws"
  deploy_name = "NotebookSample"
  vpc_cidr    = "10.210.0.0/16"
  vpn_cidr    = "10.211.0.0/16"
}

output "ecs" {
  value = {
    subnet_ids         = module.aws.subnet_ids
    cluster_name       = module.aws.ecs_cluster_name
    task_exec_role_arn = module.aws.ecs_task_exec_role_arn
  }
}

output "vpn_config" {
  value     = module.aws.vpn_config
  sensitive = true
}
