# API load balancer setup

resource "aws_lb" "serverpod" {
  name               = "${var.project_name}-serverpod"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_security_group" "api" {
  name = "${var.project_name}-api"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_lb.serverpod.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

resource "aws_lb_target_group" "api" {
  name     = "${var.project_name}-api"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.api.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }

  condition {
    host_header {
      values = ["${var.subdomain_api}.${var.top_domain}"]
    }
  }
}

resource "aws_autoscaling_attachment" "api" {
  autoscaling_group_name = aws_autoscaling_group.serverpod.id
  lb_target_group_arn    = aws_lb_target_group.api.arn
}

resource "aws_route53_record" "api" {
  zone_id = var.hosted_zone_id
  name    = "${var.subdomain_api}.${var.top_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.serverpod.dns_name}"]
}

# Insights load balancer rules

resource "aws_lb_target_group" "insights" {
  name     = "${var.project_name}-insights"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_autoscaling_attachment" "insights" {
  autoscaling_group_name = aws_autoscaling_group.serverpod.id
  lb_target_group_arn    = aws_lb_target_group.insights.arn
}

resource "aws_lb_listener_rule" "insights" {
  listener_arn = aws_lb_listener.api.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.insights.arn
  }

  condition {
    host_header {
      values = ["${var.subdomain_insights}.${var.top_domain}"]
    }
  }
}

resource "aws_route53_record" "insights" {
  zone_id = var.hosted_zone_id
  name    = "${var.subdomain_insights}.${var.top_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.serverpod.dns_name}"]
}

# Web server load balancer rules

resource "aws_lb_target_group" "web" {
  name     = "${var.project_name}-web"
  port     = 8082
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_autoscaling_attachment" "web" {
  autoscaling_group_name = aws_autoscaling_group.serverpod.id
  lb_target_group_arn    = aws_lb_target_group.web.arn
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.serverpod.arn
  port              = "80"
  protocol          = "HTTP"
  # certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

