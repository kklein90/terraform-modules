### subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.service}-${var.environment}-subnet-group"
  subnet_ids = [for subnet in data.aws_subnet.data_subnets : subnet.id]

  tags = {
    management = "terraform"
    env        = var.environment
    account    = var.account
    owner      = "devops"
    usage      = "${var.service}"
  }
}
