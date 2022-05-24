# API load balancer setup

resource "aws_lb" "api" {
  name               = "${var.project_name}-api"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_lb.api.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

resource "aws_security_group" "api" {
  name = "${var.project_name}-api"
  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_lb_target_group" "api" {
  name     = "${var.project_name}-api"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
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
  records = ["${aws_lb.api.dns_name}"]
}

# Insights load balancer setup

resource "aws_lb" "insights" {
  name               = "${var.project_name}-insights"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "insights" {
  load_balancer_arn = aws_lb.insights.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.insights.arn
  }
}

resource "aws_security_group" "insights" {
  name = "${var.project_name}-insights"
  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_route53_record" "insights" {
  zone_id = var.hosted_zone_id
  name    = "${var.subdomain_insights}.${var.top_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.insights.dns_name}"]
}