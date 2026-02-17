resource "aws_elasticache_parameter_group" "redis_single_param_grp" {
  name   = "${var.service}-${var.environment}-cache-params"
  family = "redis${var.redis-ver}"
}


resource "aws_elasticache_parameter_group" "redis_multi_param_grp" {
  count  = var.cluster-type == "multi" ? 1 : 0
  name   = "${var.service}-${var.environment}-cache-params"
  family = "redis${var.redis-ver}"
}
