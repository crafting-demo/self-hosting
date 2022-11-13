output "private_ip" {
  value = aws_instance.vm.private_ip
}

output "vscode_server_port" {
  value = var.vscode_server_port
}

output "user" {
  value = var.user
}

output "home_dir" {
  value = var.home_dir
}
