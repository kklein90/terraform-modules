
resource "aws_security_group" "redis_sec_group" {
  name        = "${var.service}-${var.environment}-redis-sec-group"
  description = "${var.service}-${var.environment}-redis-sec-group"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "Redis access from App subnets"
    from_port   = "6379"
    to_port     = "6379"
    protocol    = "tcp"
    cidr_blocks = var.subnet-cidrs
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
    owner      = "platform"
    management = "terraform"
    usage      = "${var.service}"
  }
}
