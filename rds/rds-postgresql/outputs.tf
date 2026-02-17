output "secret-name" {
  value = aws_secretsmanager_secret.rds_secret_1.name
}

output "cluster-identifier" {
  value = aws_rds_cluster.rds_pg_cluster_01.id
}

output "cluster-connection-string" {
  value = aws_rds_cluster.rds_pg_cluster_01.endpoint
}

output "kms-key-alias" {
  value = aws_kms_alias.pg_key_alias.name
}
