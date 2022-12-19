resource "aws_ec2_client_vpn_endpoint" "vpn" {
  client_cidr_block      = var.vpn_cidr
  server_certificate_arn = aws_acm_certificate.server.arn
  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.ca.arn
  }
  connection_log_options {
    enabled = false
  }

  vpc_id = aws_vpc.sample.id
}

resource "aws_ec2_client_vpn_network_association" "vpn" {
  count = length(aws_subnet.private)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = aws_subnet.private[count.index].id
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr    = aws_vpc.sample.cidr_block
  authorize_all_groups   = true
}
