resource "aws_secretsmanager_secret" "rds_secret_1" {
  name        = "/rds/${var.service}/${var.environment}/secret"
  description = "${var.region} ${var.service} ${var.environment} rds 1 secret"

  tags = {
    "environment" = var.environment
    "account"     = var.account
    "owner"       = "devops"
    "management"  = "terraform"
    "service"     = "infra"
  }
}

resource "random_password" "rds_db_password" {
  length  = 24
  special = false

}

resource "aws_secretsmanager_secret_version" "rds_secret_value" {
  depends_on    = [aws_rds_cluster.rds_pg_cluster_01]
  secret_id     = aws_secretsmanager_secret.rds_secret_1.id
  secret_string = <<EOF
{
  "username": "${aws_rds_cluster.rds_pg_cluster_01.master_username}",
  "password": "${random_password.rds_db_password.result}",
  "engine": "postgres",
  "host": "${aws_rds_cluster.rds_pg_cluster_01.endpoint}",
  "port": ${aws_rds_cluster.rds_pg_cluster_01.port},
  "dbClusterIdentifier": "${aws_rds_cluster.rds_pg_cluster_01.id}"
}
EOF

  lifecycle {
    ignore_changes = [secret_string]
  }

}
