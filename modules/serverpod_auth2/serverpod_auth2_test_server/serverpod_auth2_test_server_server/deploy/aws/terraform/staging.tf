resource "aws_launch_configuration" "staging" {
  count = var.enable_staging_server ? 1 : 0

  name_prefix = "${var.project_name}-staging-"
  image_id    = var.instance_ami
  #   image_id = data.aws_ami.amazon-linux.id
  instance_type = var.staging_instance_type
  user_data     = templatefile("init-script.sh", { runmode = "staging" })

  security_groups = [
    aws_security_group.serverpod.id,
    aws_security_group.ssh.id
  ]

  iam_instance_profile = aws_iam_instance_profile.codedeploy_profile.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "staging" {
  count = var.enable_staging_server ? 1 : 0

  min_size             = var.staging_autoscaling_min_size
  max_size             = var.staging_autoscaling_max_size
  desired_capacity     = var.staging_autoscaling_desired_capacity
  launch_configuration = aws_launch_configuration.staging[0].name
  vpc_zone_identifier  = module.vpc.public_subnets

  target_group_arns = [
    aws_lb_target_group.api_staging[0].arn,
    aws_lb_target_group.insights_staging[0].arn,
    aws_lb_target_group.web_staging[0].arn
  ]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-serverpod-staging"
    propagate_at_launch = true
  }

  tag {
    key                 = "CodeDeploy"
    value               = "${var.project_name}-staging"
    propagate_at_launch = true
  }
}

resource "aws_codedeploy_deployment_group" "staging" {
  count = var.enable_staging_server ? 1 : 0

  app_name              = aws_codedeploy_app.serverpod.name
  deployment_group_name = "${var.project_name}-staging-group"
  service_role_arn      = aws_iam_role.codedeploy_role.arn
  autoscaling_groups    = [aws_autoscaling_group.staging[0].id]
}