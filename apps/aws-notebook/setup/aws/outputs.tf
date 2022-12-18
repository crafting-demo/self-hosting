output "subnet_ids" {
  value = aws_subnet.private[*].id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "ecs_task_exec_role_arn" {
  value = aws_iam_role.ecs.arn
}

output "vpn_config" {
  value = templatefile("${path.module}/vpn_config.tftpl", {
    dns      = replace(aws_ec2_client_vpn_endpoint.vpn.dns_name, "*", var.deploy_name)
    ca_pem   = tls_self_signed_cert.ca.cert_pem
    cert_pem = tls_locally_signed_cert.client.cert_pem
    key_pem  = tls_private_key.client.private_key_pem
  })
}
