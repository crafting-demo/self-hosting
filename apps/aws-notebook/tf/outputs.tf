output "ecs_cluster_name" {
  value = data.aws_ecs_cluster.cluster.cluster_name
}

output "ecs_service_name"{
  value = aws_ecs_service.notebook.name
}
