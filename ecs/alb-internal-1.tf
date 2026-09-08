resource "aws_lb" "ecs_alb_internal_1" {
  depends_on         = [aws_s3_bucket.ecs_alb_internal_1_logs_bucket]
  name               = "ak-alb-internal-1"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_alb_internal_1_sg.id]
  subnets            = [for subnet in data.aws_subnet.services_subnet : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.ecs_alb_internal_1_logs_bucket.id
    prefix  = "ecs-alb-internal-1"
    enabled = true
  }

  tags = {
    Name      = "asterkey-alb-internal-1-${var.account}"
    owner     = "techops"
    managment = "terraform"
    account   = var.account
    env       = lookup(var.standard-env, "${var.short-env}")
    service   = "backend"
  }
}

resource "aws_lb_listener" "ecs_alb_internal_1_listener_443" {
  load_balancer_arn = aws_lb.ecs_alb_internal_1.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.asterkey_com_acm_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default_internal_target_group_1.arn
  }
}

# add additional domain cert
resource "aws_lb_listener_certificate" "ecs_internal_alb_applyanon_acm_crt" {
  listener_arn    = aws_lb_listener.ecs_alb_internal_1_listener_443.arn
  certificate_arn = data.aws_acm_certificate.applyanon_com_acm_cert.arn
}

resource "aws_lb_listener_certificate" "ecs_internal_alb_dev_asterkey_com_acm_crt" {
  listener_arn    = aws_lb_listener.ecs_alb_internal_1_listener_443.arn
  certificate_arn = data.aws_acm_certificate.dev_asterkey_com_acm_cert.arn
}


resource "aws_lb_listener" "ecs_alb_internal_listener_redirect_80" {
  load_balancer_arn = aws_lb.ecs_alb_internal_1.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "redirect"
    target_group_arn = aws_lb_target_group.default_internal_target_group_1.arn
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "default_internal_target_group_1" {
  name        = "ak-default-int-tg-${var.account}"
  port        = "80"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.vpc1.id
}

resource "aws_wafv2_web_acl_association" "internal_waf_ass" {
  resource_arn = aws_lb.ecs_alb_internal_1.arn
  web_acl_arn  = data.aws_wafv2_web_acl.internal.arn
}
