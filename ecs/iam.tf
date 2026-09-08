resource "aws_iam_role" "ecs_task_execution_role" {
  name                 = "ecsTaskExecutionRole"
  max_session_duration = "3600"
  path                 = "/"
  assume_role_policy   = data.aws_iam_policy_document.ecs_task_execution_trust_pol_doc.json
}

data "aws_iam_policy_document" "ecs_task_execution_trust_pol_doc" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ecs_task_execution_role_custom_policy" {
  name        = "ECSTaskExecutionRoleCustomerPolicy"
  description = "Add additional permissions for ECS task execution role"
  path        = "/"
  policy      = data.aws_iam_policy_document.ecs_task_execution_role_custom_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_custom_pol_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_role_custom_policy.arn
}

data "aws_iam_policy_document" "ecs_task_execution_role_custom_policy_doc" {
  statement {
    sid    = "CloudWatchAllow"
    effect = "Allow"
    actions = [
      "logs:*"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "ECSAllow"
    effect = "Allow"
    actions = [
      "ecs:*"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "SSMSessionMgr"
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "KMS"
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "IAM"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "SSM"
    effect = "Allow"
    actions = [
      "ssm:*"
    ]
    resources = [
      "*",
      "arn:aws:ssm:us-east-1:228923425684:parameter/*"
    ]
  }

  statement {
    sid    = "EC"
    effect = "Allow"
    actions = [
      "elasticache:ModifyCacheCluster",
      "elasticache:RebootCacheCluster",
      "elasticache:DescribeCacheClusters",
      "elasticache:DescribeEvents",
      "elasticache:ModifyCacheParameterGroup",
      "elasticache:DescribeCacheParameterGroups",
      "elasticache:DescribeCacheParameters",
      "elasticache:ResetCacheParameterGroup",
      "elasticache:DescribeEngineDefaultParameters"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "SES"
    effect = "Allow"
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]
    resources = [
      "arn:aws:ses:us-east-1:${lookup(var.accnt-num, "${var.env}")}:identity/lead@applyanon.com"
    ]
  }

}
