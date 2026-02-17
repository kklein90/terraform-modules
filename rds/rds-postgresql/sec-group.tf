resource "aws_security_group" "rds_sec_group" {
  name        = "${var.service}-${var.environment}-rds-sec-group"
  description = "${var.service}-${var.environment}-rds- sec-group"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "Postgresql access from App subnets"
    from_port   = "5432"
    to_port     = "5432"
    protocol    = "tcp"
    cidr_blocks = var.subnet-cidrs[var.account]
  }

  egress {
    description = "Outbound access for updates"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.service}-${var.environment}-rds-sg"
    owner      = "devops"
    management = "terraform"
    usage      = "${var.service}"
  }
}
