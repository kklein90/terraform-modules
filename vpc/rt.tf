##### public subnets route table #####
resource "aws_route_table" "public_rt_01" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-public-route-table"
  }
}

## default route to IGW
resource "aws_route" "public_rt_01" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.default_igw.id
  route_table_id         = aws_route_table.public_rt_01.id
}

resource "aws_route_table_association" "public_rt_as_01" {
  count          = 2
  subnet_id      = element(aws_subnet.public_subnets_01.*.id, count.index)
  route_table_id = aws_route_table.public_rt_01.id
}

resource "aws_main_route_table_association" "public_rt_main_as_01" {
  vpc_id         = data.aws_vpc.vpc.id
  route_table_id = aws_route_table.public_rt_01.id
}
##### END public subnets route table #####

##### private DATA subnet route tables #####
resource "aws_route_table" "private_data_rt_01" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-private-data-route-table"
  }
}

## default route to NAT GW
resource "aws_route" "private_data_rt_01" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = data.aws_nat_gateway.default_natgw.id
  route_table_id         = aws_route_table.private_data_rt_01.id
}

resource "aws_route_table_association" "private_data_rt_as_01" {
  count          = 2
  subnet_id      = element(aws_subnet.private_data_subs_01.*.id, count.index)
  route_table_id = aws_route_table.private_data_rt_01.id
}

##### private APP subnet route tables #####
resource "aws_route_table" "private_app_rt_01" {
  vpc_id = aws_vpc.vpc_01.id

  tags = {
    Name = "${var.project}-private-app-route-table"
  }
}

## default route to NAT GW
resource "aws_route" "private_app_rt_01" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = data.aws_nat_gateway.default_natgw.id
  route_table_id         = aws_route_table.private_app_rt_01.id
}

resource "aws_route_table_association" "private_app_rt_as_01" {
  count          = var.project == "nonprod" ? 2 : 0
  subnet_id      = element(aws_subnet.private_app_subs_01.*.id, count.index)
  route_table_id = aws_route_table.private_app_rt_01.id
}
