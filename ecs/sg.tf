### ALB external security group ###
resource "aws_security_group" "ecs_alb_external_1_sg" {
  name        = "${var.env}-alb-external-sg"
  description = "external loadbalancer sec group"
  vpc_id      = data.aws_vpc.vpc1.id

  ingress {
    description = "inbound TLS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "inbound http for redirect"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.env}-alb-external-sg"
    owner     = "techops"
    managment = "terraform"
    account   = var.account
    env       = lookup(var.standard-env, "${var.short-env}")
    region    = var.region
    service   = "infra"
  }
}
### end ALB external security group ###

### ALB internal security group ###
resource "aws_security_group" "ecs_alb_internal_1_sg" {
  name        = "${var.env}-alb-internal-sg"
  description = "internal loadbalancer sec group"
  vpc_id      = data.aws_vpc.vpc1.id

  ingress {
    description = "inbound TLS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "inbound http for redirect"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.env}-alb-internal-sg"
    owner     = "techops"
    managment = "terraform"
    account   = var.account
    env       = lookup(var.standard-env, "${var.short-env}")
    region    = var.region
    service   = "infra"
  }
}
### end ALB internal security group ###
