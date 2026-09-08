data "aws_ecs_cluster" "esc_cluster_01" {
  cluster_name = var.cluster-name
}

data "aws_subnets" "deployment_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc1.id]
  }
  filter {
    name   = "tag:usage"
    values = ["services"]
  }
}

data "aws_subnet" "subnets" {
  for_each = toset(data.aws_subnets.deployment_subnets.ids)
  id       = each.value
}


resource "aws_ecs_service" "comms_ms_ecs_svc" {
  name                               = "comms-ms-${var.env}-svc"
  cluster                            = data.aws_ecs_cluster.esc_cluster_01.arn
  task_definition                    = aws_ecs_task_definition.comms_ms_task_def.arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "100"
  # platform_version                   = "LATEST"
  force_new_deployment   = true
  enable_execute_command = true

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = [for subnet in data.aws_subnet.subnets : subnet.id]
    security_groups  = [aws_security_group.comms_ms_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.comms_ms_alb_target_grp.arn
    container_name   = "comms-ms-${var.env}"
    container_port   = 8081
  }

  tags = {
    owner     = "engineering"
    managment = "terraform"
    account   = var.account
    env       = lookup(var.standard-env, "${var.short-env}")
    service   = "comms-ms"
  }

  service_registries {
    # container_port = "8080"
    registry_arn = aws_service_discovery_service.svc_disc_service.arn
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [task_definition, desired_count]
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.as-max
  min_capacity       = var.as-min
  resource_id        = "service/${var.cluster-name}/${aws_ecs_service.comms_ms_ecs_svc.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_scaling_policy" {
  name               = "CpuScalingPolicy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.as-cpu-threshold
    scale_out_cooldown = 60
    scale_in_cooldown  = 60
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

  }
}
