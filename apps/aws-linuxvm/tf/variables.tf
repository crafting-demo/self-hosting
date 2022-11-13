variable "launch_template_name" {
  default = "micro-linux"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "root_volume_size" {
  type    = number
  default = 10
}

variable "key_name" {
  default = ""
}

# The download URL of VSCode server package.
variable "vscode_server_pkg_url" {
  default = "https://cloud-sandboxes.storage.googleapis.com/vscode/latest/vscode-server.tar.gz"
}

# The listening port of the VSCode server.
variable "vscode_server_port" {
  default = 8008
}

# TODO: change user/group and home_dir based on the AMI being used.
# For Ubuntu AMI images, they are ubuntu/ubuntu and /home/ubuntu.
# For Amazon Linux AMIs, they are ec2-user/ec2-user and /home/ec2-user.

variable "user" {
  default = "ubuntu"
}

variable "group" {
  default = "ubuntu"
}

variable "home_dir" {
  default = "/home/ubuntu"
}
