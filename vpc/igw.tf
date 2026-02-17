resource "aws_internet_gateway" "igw_01" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-igw"
  }
}
