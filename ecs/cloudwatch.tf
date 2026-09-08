resource "aws_cloudwatch_log_group" "ecs_cw_log_group" {
  name              = "/ecs/clusters/asterkey-cluster-01-${var.account}"
  retention_in_days = var.env == "production" ? "7" : "1"
  kms_key_id        = aws_kms_key.ecs_kms_key.arn

  tags = {
    Name      = "asterkey-ms-alb-${var.env}"
    owner     = "techops"
    managment = "terraform"
    account   = var.account
    env       = var.env
    region    = var.region
    service   = "backend"
  }
}

### this should go in the service repo tf
# resource "aws_cloudwatch_log_group" "readiness_ms_cw_log_group" {
#   name              = "/ecs/${var.env}/readiness-ms"
#   retention_in_days = "180"

#   tags = {
#     Name      = "readiness-ms-cw-loggroup-${var.env}"
#     owner     = "techops"
#     managment = "terraform"
#     account   = var.account
#     env       = var.env
#     region    = var.region
#     service   = "backend"
#   }
# }

