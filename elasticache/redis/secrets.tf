resource "aws_secretsmanager_secret" "redis_auth_secret_1" {
  count       = var.cluster-type == "multi" ? 1 : 0
  name        = "/elasticache/${var.service}-${var.environment}/authtoken"
  description = "${var.service}-${var.environment} redis auth token"

  tags = {
    "env"        = var.environment
    "account"    = var.account
    "owner"      = "platform"
    "management" = "terraform"
    "service"    = var.service
  }
}

resource "random_password" "redis_password" {
  count   = var.cluster-type == "multi" ? 1 : 0
  length  = 24
  special = false

}

resource "aws_secretsmanager_secret_version" "redis_auth_secret_value" {
  count         = var.cluster-type == "multi" ? 1 : 0
  depends_on    = [aws_elasticache_replication_group.redis_rep_group]
  secret_id     = aws_secretsmanager_secret.redis_auth_secret_1[0].id
  secret_string = random_password.redis_password[0].result

  lifecycle {
    ignore_changes = [secret_string]
  }

}
