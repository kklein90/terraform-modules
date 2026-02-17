### subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.service-name}-${var.environment}-subnet-group"
  subnet_ids = [for subnet in data.aws_subnet.data_subnet : subnet.id]

  tags = {
    management  = "terraform"
    environment = "${var.environment}"
    owner       = "platform"
    usage       = "${var.service-name}"
  }
}
