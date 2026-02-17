resource "aws_cloudwatch_log_group" "rds_postgres_log" {
  name              = "/rds/${var.service}-${var.environment}-postgresql-cluster"
  retention_in_days = 7

  tags = {
    environment = var.environment
    service     = var.service
  }
}
