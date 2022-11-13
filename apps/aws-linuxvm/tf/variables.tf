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
