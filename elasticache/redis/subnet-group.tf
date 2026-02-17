resource "aws_elasticache_subnet_group" "redis_subnets" {
  name       = "${var.service}-${var.environment}-redis-subgroup"
  subnet_ids = [for subnet in data.aws_subnet.data_subnets : subnet.id]
}
