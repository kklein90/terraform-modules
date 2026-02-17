resource "aws_security_group" "rds_sec_group" {
  name        = "${var.service-name}-${var.environment}-mysql-sg"
  description = "${var.service-name}-${var.environment}-mysql-sg"
  vpc_id      = data.aws_vpc.vpc1.id

  ingress {
    description = "Mysql access from App subnets"
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.vpc1.cidr_block]
  }

  egress {
    description = "Outbound access for updates"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.service-name}-${var.environment}-mysql-sg"
    owner      = "devops"
    management = "terraform"
    usage      = "${var.service-name}"
  }
}
