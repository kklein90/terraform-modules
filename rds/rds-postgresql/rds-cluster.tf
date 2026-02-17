resource "aws_rds_cluster" "rds_pg_cluster_01" {
  cluster_identifier              = "${var.service}-${var.environment}-postgresql-cluster"
  availability_zones              = ["${var.region}a", "${var.region}b"]
  database_name                   = var.database-name
  db_subnet_group_name            = aws_db_subnet_group.rds_subnet_group.id
  delete_automated_backups        = true
  deletion_protection             = true
  enabled_cloudwatch_logs_exports = ["postgresql"]
  engine                          = "postgres"
  engine_version                  = var.pg-ver
  kms_key_id                      = aws_kms_key.pg_key.id
  master_username                 = "postgres"
  master_password                 = random_password.rds_db_password.result
  backup_retention_period         = 14
  preferred_backup_window         = "06:58-07:28" #"07:00-09:00"
  port                            = 5432
  skip_final_snapshot             = false
  storage_encrypted               = true
  vpc_security_group_ids          = [aws_security_group.rds_sec_group.id]
  allocated_storage               = var.environment == "prd" ? 200 : 100
  iops                            = var.environment == "prd" ? 1000 : 100
  storage_type                    = "io1"
  db_cluster_instance_class       = var.instance-class

  tags = {
    "environment" = var.environment
    "region"      = var.region
    "account"     = var.account
    "owner"       = "devops"
    "management"  = "terraform"
    "service"     = var.service
  }

  lifecycle {
    ignore_changes = [
      master_password
    ]
  }
}

resource "aws_rds_cluster_instance" "rds_pg_cluster_01_instance_01" {
  count                      = var.instance-count
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true
  identifier                 = "${var.service}-${var.environment}-aurora-instance"
  cluster_identifier         = aws_rds_cluster.rds_pg_cluster_01.id
  instance_class             = var.instance-class
  db_parameter_group_name    = aws_db_parameter_group.db_param_group.name
  engine                     = aws_rds_cluster.rds_pg_cluster_01.engine
  engine_version             = aws_rds_cluster.rds_pg_cluster_01.engine_version
  promotion_tier             = 1
  monitoring_interval        = 0
  tags = {
    "environment" = var.environment
    "region"      = var.region
    "account"     = var.account
    "owner"       = "devops"
    "management"  = "terraform"
    "service"     = var.service
  }
}
