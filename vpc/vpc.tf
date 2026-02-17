resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_vpc_dhcp_options" "dhcp_opts" {
  domain_name         = var.domain-name
  domain_name_servers = [cidrhost(aws_vpc.vpc.cidr_block, 2)]

  tags = {
    Name = "${aws_vpc.vpc.id}-dhcp-opts"
  }

}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_opts.id
}
