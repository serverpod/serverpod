
# Code deploy setup

resource "aws_iam_instance_profile" "codedeploy_profile" {
  name = "${var.project_name}-codedeploy-profile"
  role = aws_iam_role.codedeploy_role.name
}

resource "aws_iam_role" "codedeploy_role" {
  name = "${var.project_name}-codedeploy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CodeDeploy",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codedeploy.amazonaws.com",
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy_role.name
}

resource "aws_iam_policy" "s3_deployment" {
  name        = "test-policy"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Get*",
        "s3:List*"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.deployment_bucket_name}/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "S3Role" {
  policy_arn = aws_iam_policy.s3_deployment.arn
  role       = aws_iam_role.codedeploy_role.name
}

resource "aws_codedeploy_app" "serverpod" {
  name = "${var.project_name}-app"
}

resource "aws_sns_topic" "serverpod" {
  name = "${var.project_name}-topic"
}

resource "aws_codedeploy_deployment_group" "serverpod" {
  app_name              = aws_codedeploy_app.serverpod.name
  deployment_group_name = "${var.project_name}-production-group"
  service_role_arn      = aws_iam_role.codedeploy_role.arn
  autoscaling_groups    = [aws_autoscaling_group.serverpod.id]
}

# S3 buckets
resource "aws_s3_bucket" "deployment" {
  bucket        = var.deployment_bucket_name
  force_destroy = true

  tags = {
    Name = "${var.project_name} deployment"
  }
}

resource "aws_s3_bucket_acl" "deployment" {
  bucket = aws_s3_bucket.deployment.id
  acl    = "private"
}