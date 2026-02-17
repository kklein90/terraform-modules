resource "aws_kms_key" "redis_key" {
  count                   = var.cluster-type == "multi" ? 1 : 0
  enable_key_rotation     = true
  description             = "${var.service} ${var.environment} redis encryption key"
  deletion_window_in_days = 7

  tags = {
    Name        = "${var.environment}-${var.service}-kms-key"
    owner       = "platform"
    managment   = "terraform"
    account     = var.account
    environment = var.environment
    service     = var.service
  }
}

resource "aws_kms_alias" "redis_key_alias" {
  count         = var.cluster-type == "multi" ? 1 : 0
  name          = "alias/${var.service}-${var.environment}-redis-key"
  target_key_id = aws_kms_key.redis_key[0].key_id
}

resource "aws_kms_key_policy" "redis_key_pol" {
  count  = var.cluster-type == "multi" ? 1 : 0
  key_id = aws_kms_key.redis_key[0].id
  policy = jsonencode({
    Id = "encryption-rest"
    Statement = [
      {
        Action = "kms:*",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.account-id}:root"
        },
        Resource = "*",
        Sid      = "Enable IAM User permissions"
      },
      {
        Effect : "Allow",
        Principal : {
          Service : "logs.${var.region}.amazonaws.com"
        },
        Action : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt",
          "kms:GenerateDataKey",
          "kms:Describe"
        ],
        Resource : "*",
        Sid = "Log permissions"
        Condition : {
          ArnEquals : {
            "kms:EncryptionContext:aws:logs:arn" : [aws_cloudwatch_log_group.redis_engine_log[0].arn]
          }
        }
      }
    ]
    Version = "2012-10-17"
  })
}
