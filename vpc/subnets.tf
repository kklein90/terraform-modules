resource "aws_subnet" "public_subnets" {
  count                   = 2
  vpc_id                  = data.aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 1, count.index + 3)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name  = "${var.project}-public-${data.aws_availability_zones.available.names[count.index]}"
    usage = "public"
    az    = data.aws_availability_zones.available.names[count.index]
    tgw   = "false"
  }
}

resource "aws_subnet" "private_app_subnets" {
  count                   = 3
  vpc_id                  = data.aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 1, count.index + 7)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name  = "${var.project}-app-${data.aws_availability_zones.available.names[count.index]}"
    usage = "app"
    az    = data.aws_availability_zones.available.names[count.index]
    tgw   = "true"
  }
}

resource "aws_subnet" "private_data_subnets" {
  count                   = 3
  vpc_id                  = data.aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 1, count.index + 14)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name  = "${var.project}-data-${data.aws_availability_zones.available.names[count.index]}"
    usage = "data"
    az    = data.aws_availability_zones.available.names[count.index]
    tgw   = "false"
  }
}
