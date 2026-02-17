resource "aws_ecr_repository" "ecr_repo" {
  for_each             = toset(var.container-repos)
  name                 = each.key
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name      = var.service
    owner     = "platform"
    managment = "terraform"
    account   = var.account
    env       = var.environment
    service   = var.service
  }
}

resource "aws_ecr_repository_policy" "ecr_repo_pol" {
  for_each   = toset(var.container-repos)
  repository = aws_ecr_repository.ecr_repo[each.key].name

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "GithubRunnerAllow",
      "Effect": "Allow",

      "Principal": {
        "AWS": ${var.permitted-arns}
      },

      "Action": "ecr:*"
    }
  ]
}
EOF
}

resource "aws_ecr_lifecycle_policy" "ecr_repo_lifecycle_pol" {
  for_each   = toset(var.container-repos)
  repository = aws_ecr_repository.ecr_repo[each.key].name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 50 tagged images",
            "selection": {
                "tagStatus": "tagged",
                "tagPatternList": ["*"],
                "countType": "imageCountMoreThan",
                "countNumber": 50
            },
            "action": {
                "type": "expire"
            }
        },

        {
            "rulePriority": 2,
            "description": "Expire untagged images older than 30 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF

}
