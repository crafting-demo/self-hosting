data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"

  dynamic "filter" {
    for_each = var.az_filter
    content {
      name   = filter.key
      values = filter.value
    }
  }
}

resource "aws_vpc" "sample" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "private" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.sample.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.sample.cidr_block, 4, 8 + count.index)
  tags = {
    Name = "${var.deploy_name}-private${count.index}"
  }
}
