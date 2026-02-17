resource "aws_elasticache_cluster" "redis_cluster" {
  count                      = var.cluster-type == "single" ? 1 : 0
  cluster_id                 = "${var.service}-${var.environment}-001"
  engine                     = "redis"
  node_type                  = var.node-type
  num_cache_nodes            = 1
  parameter_group_name       = aws_elasticache_parameter_group.redis_single_param_grp.name
  port                       = 6379
  security_group_ids         = [aws_security_group.redis_sec_group.id]
  subnet_group_name          = aws_elasticache_subnet_group.redis_subnets.name
  transit_encryption_enabled = true
}

resource "aws_elasticache_replication_group" "redis_rep_group" {
  count                      = var.cluster-type == "multi" ? 1 : 0
  automatic_failover_enabled = true
  subnet_group_name          = aws_elasticache_subnet_group.redis_subnets.name
  replication_group_id       = "${var.service}-${var.environment}-001"
  description                = "Redis cluster for ${var.service}-${var.environment} api"
  node_type                  = var.node-type
  parameter_group_name       = aws_elasticache_parameter_group.redis_multi_param_grp[0].name
  port                       = 6379
  multi_az_enabled           = true
  num_node_groups            = var.shards
  replicas_per_node_group    = 1
  at_rest_encryption_enabled = true
  kms_key_id                 = aws_kms_key.redis_key[0].id
  transit_encryption_enabled = true
  auth_token                 = random_password.redis_password[0].result
  security_group_ids         = [aws_security_group.redis_sec_group.id]
  security_group_names       = []
  snapshot_retention_limit   = 2

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis_slow_log[0].name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }

  lifecycle {
    ignore_changes = [
      kms_key_id,
      auth_token
    ]
  }

  apply_immediately = true
}
