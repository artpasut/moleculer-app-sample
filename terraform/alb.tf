resource "aws_lb" "alb" {
  name            = format("%s-alb", var.name)
  subnets         = module.vpc.public_subnet_ids
  security_groups = [aws_security_group.alb.id]
  tags = merge(
    var.tags,
    { "Name" = format("%s-alb", var.name) },
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.id
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

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.alb_info.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_api_service.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  condition {
    host_header {
      values = [var.alb_info.api_domain_name]
    }
  }
}

resource "aws_security_group" "alb" {
  name        = format("%s-alb-sg", var.name)
  description = format("%s application load balancer security group", var.name)
  vpc_id      = module.vpc.vpc_id

  tags = merge(
    var.tags,
    { "Name" = format("%s-alb-sg", var.name) },
  )
}

resource "aws_security_group_rule" "alb_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_ingress_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_egress" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = module.ec2_api_service.security_group_id
}

resource "aws_lb_target_group" "ec2_api_service" {
  name     = format("%s-api-service-tg", var.name)
  port     = var.api_service_info.service_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.api_service_info.health_check_path
    unhealthy_threshold = "2"
  }
  tags = merge(
    var.tags,
    { "Name" = format("%s-api-service-tg", var.name) },
  )
}

resource "aws_lb_target_group_attachment" "ec2_api_service" {
  target_group_arn = aws_lb_target_group.ec2_api_service.arn
  target_id        = module.ec2_api_service.id
  port             = var.api_service_info.service_port
}
