resource "aws_internet_gateway" "sample" {
  count = var.internet_access ? 1 : 0

  vpc_id = aws_vpc.sample.id
}

resource "aws_subnet" "public" {
  count = var.internet_access ? length(data.aws_availability_zones.available.names) : 0

  vpc_id            = aws_vpc.sample.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.sample.cidr_block, 4, count.index)
  tags = {
    Name = "${var.deploy_name}-public${count.index}"
  }
}

resource "aws_eip" "nat" {
  count = var.internet_access ? length(data.aws_availability_zones.available.names) : 0

  vpc = true
  depends_on = [
    aws_internet_gateway.sample[0]
  ]
}

resource "aws_nat_gateway" "public" {
  count = var.internet_access ? length(data.aws_availability_zones.available.names) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}

resource "aws_route_table" "public" {
  count = var.internet_access ? 1 : 0

  vpc_id = aws_vpc.sample.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sample[0].id
  }
}

resource "aws_route_table_association" "public" {
  count = var.internet_access ? length(data.aws_availability_zones.available.names) : 0

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table" "private" {
  count = var.internet_access ? length(data.aws_availability_zones.available.names) : 0

  vpc_id = aws_vpc.sample.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public[count.index].id
  }

  tags = {
    Name = "${var.deploy_name}-private${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count = var.internet_access ? length(data.aws_availability_zones.available.names) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
