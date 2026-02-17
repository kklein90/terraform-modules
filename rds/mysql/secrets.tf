resource "aws_secretsmanager_secret" "rds_secret_1" {
  name        = "/rds/${var.service-name}/${var.environment}/db-secret"
  description = "${var.region} ${var.service-name} ${var.environment} rds 1 secret"

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

resource "aws_secretsmanager_secret_version" "us_east_prod_rds_secret_value" {
  depends_on    = [aws_db_instance.default]
  secret_id     = aws_secretsmanager_secret.rds_secret_1.id
  secret_string = <<EOF
{
  "username": "${aws_db_instance.default.username}",
  "password": "${random_password.rds_db_password.result}",
  "engine": "postgres",
  "host": "${aws_db_instance.default.address}",
  "port": ${aws_db_instance.default.port},
  "dbClusterIdentifier": "${aws_db_instance.default.id}"
}
EOF

  lifecycle {
    ignore_changes = [secret_string]
  }

}
