resource "aws_vpc_endpoint" "s3" {
  count = var.internet_access ? 0 : 1

  vpc_id            = aws_vpc.sample.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_vpc.sample.main_route_table_id]

}

resource "aws_vpc_endpoint" "ecr_dkr" {
  count = var.internet_access ? 0 : 1

  vpc_id              = aws_vpc.sample.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id

}

resource "aws_vpc_endpoint" "ecr_api" {
  count = var.internet_access ? 0 : 1

  vpc_id              = aws_vpc.sample.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id
}

resource "aws_vpc_endpoint" "logs" {
  count = var.internet_access ? 0 : 1
    
  vpc_id              = aws_vpc.sample.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id
}
