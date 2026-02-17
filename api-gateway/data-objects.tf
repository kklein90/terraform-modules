data "aws_vpc" "vpc1" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc-name}"]
  }
}

data "aws_acm_certificate" "custom_domain" {
  domain      = var.custom-domain-name
  statuses    = ["ISSUED"]
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "custom_domain_zone" {
  name         = local.domain-name
  private_zone = false
}

data "aws_lb" "internal_alb" {
  name = var.internal-alb-name
}

