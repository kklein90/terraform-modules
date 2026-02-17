resource "aws_db_parameter_group" "db_param_group" {
  name   = "${var.service}-${var.environment}-param-group"
  family = "postgres17"
}
