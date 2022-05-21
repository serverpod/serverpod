# API load balancer setup

resource "aws_lb" "api_staging" {
  count = var.enable_staging_server ? 1 : 0

  name               = "${var.project_name}-api-staging"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "api_staging" {
  count = var.enable_staging_server ? 1 : 0

  load_balancer_arn = aws_lb.api.arn
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

  name     = "${var.project_name}-api"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_autoscaling_attachment" "api_staging" {
  count = var.enable_staging_server ? 1 : 0

  autoscaling_group_name = aws_autoscaling_group.staging[0].id
  lb_target_group_arn    = aws_lb_target_group.api_staging[0].arn
}

resource "aws_route53_record" "api_staging" {
  count = var.enable_staging_server ? 1 : 0

  zone_id = var.hosted_zone_id
  name    = "${var.subdomain_staging}.${var.top_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.api.dns_name}"]
}

# Insights load balancer setup

resource "aws_lb" "insights_staging" {
  count = var.enable_staging_server ? 1 : 0

  name               = "${var.project_name}-insights-staging"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "insights_staging" {
  count = var.enable_staging_server ? 1 : 0

  load_balancer_arn = aws_lb.insights_staging[0].arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.insights_staging[0].arn
  }
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

resource "aws_route53_record" "insights_staging" {
  count = var.enable_staging_server ? 1 : 0

  zone_id = var.hosted_zone_id
  name    = "${var.subdomain_insights_staging}.${var.top_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.insights.dns_name}"]
}