data "aws_acm_certificate" "asterkey_com_acm_cert" {
  domain = "*.asterkey.com"
  types  = ["AMAZON_ISSUED"]
}

data "aws_acm_certificate" "applyanon_com_acm_cert" {
  domain = "*.applyanon.com"
  types  = ["AMAZON_ISSUED"]
}

data "aws_acm_certificate" "dev_asterkey_com_acm_cert" {
  domain = "*.${var.short-env}.asterkey.com"
  types  = ["AMAZON_ISSUED"]
}

## accounts
variable "accnt-num" {
  type = map(string)
  default = {
    develop     = "228923425684"
    development = "228923425684"
    staging     = "464677946080"
    production  = "380735047240"
  }
}

## subnets & vpcs
variable "vpc-name" {
  type = map(string)
  default = {
    develop     = "asterkey-develop"
    development = "asterkey-development"
    staging     = "asterkey-staging"
    production  = "asterkey-prod"
  }
}

data "aws_vpc" "vpc1" {
  filter {
    name   = "tag:Name"
    values = ["${lookup(var.vpc-name, "${var.account}")}"]
  }
}

# public subnet lookup
data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc1.id]
  }
  filter {
    name   = "tag:usage"
    values = ["public"]
  }
}

data "aws_subnet" "public_subnet" {
  for_each = toset(data.aws_subnets.public_subnets.ids)
  id       = each.value
}

# svc subnets
data "aws_subnets" "services_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc1.id]
  }
  filter {
    name   = "tag:usage"
    values = ["services"]
  }
}

data "aws_subnet" "services_subnet" {
  for_each = toset(data.aws_subnets.services_subnets.ids)
  id       = each.value
}

data "aws_wafv2_web_acl" "internal" {
  name  = "asterkey-waf2-internal-${var.env}-${var.region}"
  scope = "REGIONAL"
}

data "aws_wafv2_web_acl" "external" {
  name  = "asterkey-waf-${var.env}-${var.region}"
  scope = "REGIONAL"
}
## subnets & vpcs
variable "vpc-name" {
  type = map(string)
  default = {
    develop    = "asterkey-development"
    staging    = "asterkey-staging"
    production = "asterkey-prod"
  }
}

data "aws_vpc" "vpc1" {
  filter {
    name   = "tag:Name"
    values = ["${lookup(var.vpc-name, "${var.account}")}"]
  }
}

data "aws_caller_identity" "current" {}

# svc subnets
data "aws_subnets" "services_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc1.id]
  }
  filter {
    name   = "tag:usage"
    values = ["services"]
  }
}

data "aws_subnet" "services_subnet" {
  for_each = toset(data.aws_subnets.services_subnets.ids)
  id       = each.value
}
