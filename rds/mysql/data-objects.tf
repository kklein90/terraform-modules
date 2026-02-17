data "aws_vpc" "vpc1" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc-name}"]
  }
}

# app subnet lookup
data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc1.id]
  }
  filter {
    name   = "tag:usage"
    values = ["app"]
  }
  filter {
    name   = "tag:az"
    values = ["us-east-1a", "us-east-1b", "us-east-1c"]
  }
}

data "aws_subnet" "subnet" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value
}

# data subnet lookup
data "aws_subnets" "data_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc1.id]
  }
  filter {
    name   = "tag:usage"
    values = ["data"]
  }
  filter {
    name   = "tag:az"
    values = ["us-east-1a", "us-east-1b", "us-east-1c"]
  }
}

data "aws_subnet" "data_subnet" {
  for_each = toset(data.aws_subnets.data_subnets.ids)
  id       = each.value
}


