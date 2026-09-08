resource "aws_ecs_task_definition" "comms_ms_task_def" {
  family                   = "comms-ms-${var.env}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  task_role_arn            = var.task-role-arn
  execution_role_arn       = var.execution-role-arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = {
    owner     = "engineering"
    managment = "terraform"
    account   = var.account
    env       = lookup(var.standard-env, "${var.short-env}")
    service   = "comms-ms"
  }


  container_definitions = <<TASKDEF
[
    {
        "name": "comms-ms-${var.env}",
        "image": "228923425684.dkr.ecr.us-east-1.amazonaws.com/comms-ms:latest",
        "cpu": 0,
        "portMappings": [
            {
                "name": "8081",
                "containerPort": 8081,
                "hostPort": 8081,
                "protocol": "tcp",
                "appProtocol": "http"
            }
        ],
        "essential": true,
        "environment": [
                {
                    "name": "APPNAME",
                    "value": "-APPNAME"
                },
                {
                    "name": "DATADOG_TRACE_AGENT_HOSTNAME",
                    "value": "DATADOG-TRACE-AGENT-HOSTNAME"
                },
                {
                    "name": "DD_AGENT_MAJOR_VERSION",
                    "value": "DD-AGENT-MAJOR-VERSION"
                },
                {
                    "name": "DD_API_KEY",
                    "value": "DD-API-KEY"
                },
                {
                    "name": "DD_APM_ENABLED",
                    "value": "DD-APM-ENABLED"
                },
                {
                    "name": "DD_ENV",
                    "value": "DD-ENV"
                },
                {
                    "name": "PORT",
                    "value": "-PORT"
                },
                {
                    "name": "AK_API_KEY",
                    "value": "AK-API-KEY"
                },
                {
                    "name": "DATABASE_URL",
                    "value": "DATABASEURL"
                },
                {
                    "name": "LOGLEVEL",
                    "value": "-LOGLEVEL"
                }
        ],
        "environmentFiles": [],
        "mountPoints": [],
        "volumesFrom": [],
        "ulimits": [],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/comms-ms/${var.env}",
                "awslogs-region": "us-east-1",
                "awslogs-stream-prefix": "ecs"
            },
            "secretOptions": []
        }
    }
]
TASKDEF

  lifecycle {
    ignore_changes = [container_definitions, family, requires_compatibilities, cpu, memory, tags]
  }

}
