resource "aws_rds_cluster" "aurora_cluster_01" {
  cluster_identifier              = "${var.service-name}-${var.environment}-aurora-cluster"
  availability_zones              = var.rds-cluster-azs
  database_name                   = var.service-name
  db_subnet_group_name            = aws_db_subnet_group.rds_subnet_group.id
  delete_automated_backups        = true
  deletion_protection             = true
  enabled_cloudwatch_logs_exports = ["postgresql"]
  engine                          = "aurora-postgresql"
  kms_key_id                      = lookup(var.rds_kms_key[var.environment], var.region)
  master_username                 = var.db-master-username
  master_password                 = random_password.rds_db_password.result
  backup_retention_period         = 10
  preferred_backup_window         = "06:58-07:28" #"07:00-09:00"
  port                            = 5432
  skip_final_snapshot             = true
  storage_encrypted               = true
  vpc_security_group_ids          = [aws_security_group.rds_sec_group.id]

  tags = {
    "environment" = var.environment
    "region"      = var.region
    "account"     = var.account
    "owner"       = "platform"
    "management"  = "terraform"
    "service"     = "${var.service-name}"
  }

  lifecycle {
    ignore_changes = [
      master_password
    ]
  }
}

resource "aws_rds_cluster_instance" "aurora_cluster_01_instance_01" {
  count                      = var.instance-count
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true
  identifier                 = "${var.service-name}-${var.environment}-aurora-instance-${count.index}"
  cluster_identifier         = aws_rds_cluster.aurora_cluster_01.id
  instance_class             = var.instance-class
  engine                     = aws_rds_cluster.aurora_cluster_01.engine
  engine_version             = aws_rds_cluster.aurora_cluster_01.engine_version
  promotion_tier             = 1
  monitoring_interval        = 0
  tags = {
    "environment" = var.environment
    "region"      = var.region
    "account"     = var.account
    "owner"       = "platform"
    "management"  = "terraform"
    "service"     = "${var.service-name}"
  }
}



