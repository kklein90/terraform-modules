resource "aws_lb" "ecs_alb_external_1" {
  depends_on         = [aws_s3_bucket.ecs_alb_external_1_logs_bucket]
  name               = "ak-alb-external-1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_alb_external_1_sg.id]
  subnets            = [for subnet in data.aws_subnet.public_subnet : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.ecs_alb_external_1_logs_bucket.id
    prefix  = "ecs-alb-external-1"
    enabled = true
  }

  tags = {
    Name      = "asterkey-alb-external-1-${var.account}"
    owner     = "techops"
    managment = "terraform"
    account   = var.account
    env       = lookup(var.standard-env, "${var.short-env}")
    service   = "backend"
  }
}

resource "aws_lb_listener" "ecs_alb_external_1listener_443" {
  load_balancer_arn = aws_lb.ecs_alb_external_1.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.asterkey_com_acm_cert.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "unauthorized"
      status_code  = "401"
    }
  }
}

# add additional domain cert
resource "aws_lb_listener_certificate" "ecs_alb_applyanon_acm_crt" {
  listener_arn    = aws_lb_listener.ecs_alb_external_1listener_443.arn
  certificate_arn = data.aws_acm_certificate.applyanon_com_acm_cert.arn
}


resource "aws_lb_listener" "ecs_alb_external_listener_redirect_80" {
  load_balancer_arn = aws_lb.ecs_alb_external_1.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_lb_target_group" "default_target_group_1" {
  name        = "asterkey-default-tg-${var.account}"
  port        = "80"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.vpc1.id
}

resource "aws_wafv2_web_acl_association" "external_waf_ass" {
  resource_arn = aws_lb.ecs_alb_external_1.arn
  web_acl_arn  = data.aws_wafv2_web_acl.external.arn
}
