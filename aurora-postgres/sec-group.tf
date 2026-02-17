resource "aws_security_group" "rds_sec_group" {
  name        = "${var.service-name}-${var.environment}-sec-group"
  description = "${var.service-name}-${var.environment}-sec-group"
  vpc_id      = data.aws_vpc.vpc1.id

  ingress {
    description = "Postgresql access from App subnets"
    from_port   = "5432"
    to_port     = "5432"
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
    Name       = "${var.service-name}-${var.environment}-rds-sg"
    owner      = "platform"
    management = "terraform"
    usage      = "${var.service-name}"
  }
}
