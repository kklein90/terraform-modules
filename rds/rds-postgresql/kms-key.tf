resource "aws_kms_key" "pg_key" {
  enable_key_rotation     = true
  description             = "${var.service} ${var.environment} Postgres encryption key"
  deletion_window_in_days = 7

  tags = {
    Name        = "${var.environment}-${var.service}-kms-key"
    owner       = "devops"
    managment   = "terraform"
    account     = var.account
    environment = var.environment
    service     = var.service
  }
}

resource "aws_kms_alias" "pg_key_alias" {
  name          = "alias/${var.service}-${var.environment}-postgres-key"
  target_key_id = aws_kms_key.pg_key.key_id
}

resource "aws_kms_key_policy" "pg_key_pol" {
  key_id = aws_kms_key.pg_key.id
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
            "kms:EncryptionContext:aws:logs:arn" : [aws_cloudwatch_log_group.rds_postgres_log.arn]
          }
        }
      }
    ]
    Version = "2012-10-17"
  })
}
