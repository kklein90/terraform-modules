resource "aws_db_instance" "default" {
  allocated_storage       = 10
  backup_retention_period = 7
  db_name                 = var.service-name
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.instance-size
  identifier              = "platform-web-mysql"
  multi_az                = false
  username                = "root"
  password                = random_password.rds_db_password.result
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true

  tags = {
    management  = "terraform"
    environment = "${var.environment}"
    owner       = "devops"
    usage       = "${var.service-name}"
  }
}



