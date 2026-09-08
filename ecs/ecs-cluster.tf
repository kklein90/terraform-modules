resource "aws_ecs_cluster" "ecs_cluster_01" {
  depends_on = [aws_cloudwatch_log_group.ecs_cw_log_group]
  name       = "asterkey-cluster-01-${var.account}"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.ecs_kms_key.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_cw_log_group.name
      }
    }

  }

  tags = {
    Name      = "asterkey-cluster-01-${var.account}"
    owner     = "techops"
    managment = "terraform"
    account   = var.account
    env       = lookup(var.standard-env, "${var.short-env}")
    region    = var.region
    service   = "infra"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags]
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_01_cap_provider" {
  cluster_name = aws_ecs_cluster.ecs_cluster_01.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 100
    base              = 1
  }
}
