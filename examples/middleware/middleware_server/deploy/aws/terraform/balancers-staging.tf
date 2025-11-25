# API load balancer setup

resource "aws_lb" "serverpod_staging" {
  count = var.enable_staging_server ? 1 : 0

  name               = "${var.project_name}-serverpod-staging"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "api_staging" {
  count = var.enable_staging_server ? 1 : 0

  load_balancer_arn = aws_lb.serverpod_staging[0].arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_staging[0].arn
  }
}

resource "aws_lb_target_group" "api_staging" {
  count = var.enable_staging_server ? 1 : 0

  name     = "${var.project_name}-api-staging"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_listener_rule" "api_staging" {
  count = var.enable_staging_server ? 1 : 0

  listener_arn = aws_lb_listener.api_staging[0].arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_staging[0].arn
  }

  condition {
    host_header {
      values = ["${var.subdomain_api_staging}.${var.top_domain}"]
    }
  }
}

resource "aws_autoscaling_attachment" "api_staging" {
  count = var.enable_staging_server ? 1 : 0

  autoscaling_group_name = aws_autoscaling_group.staging[0].id
  lb_target_group_arn    = aws_lb_target_group.api_staging[0].arn
}

resource "aws_route53_record" "api_staging" {
  count = var.enable_staging_server ? 1 : 0

  zone_id = var.hosted_zone_id
  name    = "${var.subdomain_api_staging}.${var.top_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.serverpod_staging[0].dns_name}"]
}

resource "aws_lb_target_group" "insights_staging" {
  count = var.enable_staging_server ? 1 : 0

  name     = "${var.project_name}-insights-staging"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_autoscaling_attachment" "insights_staging" {
  count = var.enable_staging_server ? 1 : 0

  autoscaling_group_name = aws_autoscaling_group.staging[0].id
  lb_target_group_arn    = aws_lb_target_group.insights_staging[0].arn
}

resource "aws_lb_listener_rule" "insights_staging" {
  count = var.enable_staging_server ? 1 : 0

  listener_arn = aws_lb_listener.api_staging[0].arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.insights_staging[0].arn
  }

  condition {
    host_header {
      values = ["${var.subdomain_insights_staging}.${var.top_domain}"]
    }
  }
}

resource "aws_route53_record" "insights_staging" {
  count = var.enable_staging_server ? 1 : 0

  zone_id = var.hosted_zone_id
  name    = "${var.subdomain_insights_staging}.${var.top_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.serverpod_staging[0].dns_name}"]
}

resource "aws_lb_target_group" "web_staging" {
  count = var.enable_staging_server ? 1 : 0

  name     = "${var.project_name}-web-staging"
  port     = 8082
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_autoscaling_attachment" "web_staging" {
  count = var.enable_staging_server ? 1 : 0

  autoscaling_group_name = aws_autoscaling_group.staging[0].id
  lb_target_group_arn    = aws_lb_target_group.web_staging[0].arn
}


resource "aws_lb_listener" "web_staging" {
  count = var.enable_staging_server ? 1 : 0

  load_balancer_arn = aws_lb.serverpod_staging[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_staging[0].arn
  }
}
