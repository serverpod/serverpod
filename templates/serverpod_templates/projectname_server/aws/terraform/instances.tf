
# EC2 auto scaling cluster and security groups

data "aws_availability_zones" "available" {
  state = "available"
}

# TODO: Fix?
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_configuration" "serverpod" {
  name_prefix = "${var.project_name}-"
  image_id    = var.instance_ami
  #   image_id = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type
  user_data     = templatefile("init-script.sh", {runmode="production"})

  security_groups = [
    aws_security_group.serverpod.id,
    aws_security_group.ssh.id
  ]

  iam_instance_profile = aws_iam_instance_profile.codedeploy_profile.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "serverpod" {
  min_size             = var.autoscaling_min_size
  max_size             = var.autoscaling_max_size
  desired_capacity     = var.autoscaling_desired_capacity
  launch_configuration = aws_launch_configuration.serverpod.name
  vpc_zone_identifier  = module.vpc.public_subnets

  target_group_arns = [
    aws_lb_target_group.api.arn,
    aws_lb_target_group.insights.arn
  ]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-serverpod"
    propagate_at_launch = true
  }

  tag {
    key                 = "CodeDeploy"
    value               = var.project_name
    propagate_at_launch = true
  }
}

resource "aws_security_group" "serverpod" {
  name = "${var.project_name}-serverpod"

  ingress {
    from_port       = 8080
    to_port         = 8081
    protocol        = "tcp"
    security_groups = [aws_security_group.api.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "ssh" {
  name = "${var.project_name}-ssh"

  ingress {
    from_port   = 22
    to_port     = 22
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
