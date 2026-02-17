resource "aws_cloudwatch_log_group" "redis_slow_log" {
  count             = var.cluster-type == "multi" ? 1 : 0
  name              = "/elasticache/${var.service}-${var.environment}/slow-log"
  retention_in_days = "7"


  tags = {
    managment = "terraform"
    account   = var.account
    env       = var.environment
    service   = var.service
  }
}

resource "aws_cloudwatch_log_group" "redis_engine_log" {
  count             = var.cluster-type == "multi" ? 1 : 0
  name              = "/elasticache/${var.service}-${var.environment}/engine-log"
  retention_in_days = "7"

  tags = {
    managment = "terraform"
    account   = var.account
    env       = var.environment
    service   = var.service
  }
}
