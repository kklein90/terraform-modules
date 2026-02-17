data "aws_region" "current-region" {}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc-name}"]
  }
}

# look up for subnets deployed by sc-tf-vpc, first find them, then enumerate them
# the list of subnets can be access using:  [for subnet in data.aws_subnet.data_subnets : subnet.id]   <-- note this is for the data subnets
data "aws_subnets" "app_subnet_lookup" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:usage"
    values = ["app"]
  }
}

data "aws_subnet" "app_subnets" {
  for_each = toset(data.aws_subnets.app_subnet_lookup.ids)
  id       = each.value
}

data "aws_subnets" "data_subnet_lookup" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:usage"
    values = ["data"]
  }
}

data "aws_subnet" "data_subnets" {
  for_each = toset(data.aws_subnets.data_subnet_lookup.ids)
  id       = each.value
}

data "aws_subnets" "public_subnet_lookup" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  filter {
    name   = "tag:usage"
    values = ["public"]
  }
}

data "aws_subnet" "public_subnets" {
  for_each = toset(data.aws_subnets.public_subnet_lookup.ids)
  id       = each.value
}
