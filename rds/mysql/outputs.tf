output "rds_endpoint" {
  value = aws_db_instance.default.address
}

output "rds_user_secret" {
  value = aws_secretsmanager_secret.rds_secret_1.name
}
