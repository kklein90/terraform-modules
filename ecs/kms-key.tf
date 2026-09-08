resource "aws_kms_key" "ecs_kms_key" {
  description             = "ECS kms key 1"
  deletion_window_in_days = 30

  tags = {
    Name      = "ECS kms key 1"
    owner     = "techops"
    managment = "terraform"
    account   = var.account
    env       = lookup(var.standard-env, "${var.short-env}")
    region    = var.region
    service   = "infra"
  }
}

resource "aws_kms_alias" "ecs_kms_key_alias" {
  name          = "alias/ecs-kms-key-1"
  target_key_id = aws_kms_key.ecs_kms_key.key_id
}
