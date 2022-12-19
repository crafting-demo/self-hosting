variable "deploy_name" {
  description = "The unique name to be associated with resources' Name tag. Also used for ECS cluster name."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR of the new VPC."
  type        = string
}

variable "vpn_cidr" {
  description = "CIDR for VPN network, must not overlap with VPC CIDR."
  type        = string
}

variable "az_filter" {
  description = <<-EOS
  Filter the availability zones.
  If unspecified, all zones will be used.
  Only up to 7 availability zones are supported.
  EOS
  type        = map(list(string))
  default     = {}
}

variable "internet_access" {
  description = "Allow the workload to access Internet."
  default     = true
}
