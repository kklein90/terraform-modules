#### external alb bucket ####
resource "aws_s3_bucket" "ecs_alb_external_1_logs_bucket" {
  bucket = "asterkey-${var.env}-ecs-alb-external-logs-${var.region}"

  tags = {
    Name      = "asterkey-${var.env}-ecs-alb-external-logs-${var.region}"
    owner     = "techops"
    managment = "terraform"
    account   = var.account
    env       = lookup(var.standard-env, "${var.short-env}")
    region    = var.region
    service   = "backend"
  }
}

resource "aws_s3_object" "ecs_alb_external_logging_path_1" {
  bucket = aws_s3_bucket.ecs_alb_external_1_logs_bucket.id
  key    = "ecs-alb-external-1/"
}

resource "aws_s3_bucket_policy" "ecs-alb-logs-bucket-pol" {
  bucket = aws_s3_bucket.ecs_alb_external_1_logs_bucket.id
  policy = data.aws_iam_policy_document.ecs_alb_external_logs_bucket_pol.json
}

data "aws_iam_policy_document" "ecs_alb_external_logs_bucket_pol" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.stage_id, var.prod_id, var.dev_id]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::asterkey-${var.env}-ecs-alb-external-logs-${var.region}/ecs-alb-external-1"
    ]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::127311923021:root"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::asterkey-${var.env}-ecs-alb-external-logs-${var.region}/ecs-alb-external-1/*"
    ]
  }
}

#### internal alb bucket ####
resource "aws_s3_bucket" "ecs_alb_internal_1_logs_bucket" {
  bucket = "asterkey-${var.env}-ecs-alb-internal-logs-${var.region}"

  tags = {
    Name      = "asterkey-${var.env}-ecs-alb-internal-logs-${var.region}"
    owner     = "techops"
    managment = "terraform"
    account   = var.account
    env       = lookup(var.standard-env, "${var.short-env}")
    region    = var.region
    service   = "backend"
  }
}

resource "aws_s3_object" "ecs_alb_internal_logging_path_1" {
  bucket = aws_s3_bucket.ecs_alb_internal_1_logs_bucket.id
  key    = "ecs-alb-internal-1/"
}

resource "aws_s3_bucket_policy" "ecs-alb-internal-logs-bucket-pol" {
  bucket = aws_s3_bucket.ecs_alb_internal_1_logs_bucket.id
  policy = data.aws_iam_policy_document.ecs_alb_internal_logs_bucket_pol.json
}

data "aws_iam_policy_document" "ecs_alb_internal_logs_bucket_pol" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.stage_id, var.prod_id, var.dev_id]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::asterkey-${var.env}-ecs-alb-internal-logs-${var.region}/ecs-alb-internal-1"
    ]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::127311923021:root"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::asterkey-${var.env}-ecs-alb-internal-logs-${var.region}/ecs-alb-internal-1/*"
    ]
  }
}

#### end internal alb bucket ####
