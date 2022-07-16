# Project setup

variable "project_name" {
  description = "Name of your project"
  type        = string
}

variable "aws_region" {
  description = "The region to deploy the configuration to"
  type        = string
}

variable "enable_redis" {
  description = "Deploy a managed Redis server"
  type        = bool
}

variable "enable_staging_server" {
  description = "Deploy a staging server"
  type        = bool
}

# Instance setup

variable "instance_ami" {
  description = "The ami used for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type used for the instance"
  type        = string
}

variable "autoscaling_min_size" {
  description = "Minimum size for the autoscaling pool"
  type        = number
}

variable "autoscaling_max_size" {
  description = "Maximum size for the autoscaling pool"
  type        = number
}

variable "autoscaling_desired_capacity" {
  description = "Desired size for the autoscaling pool"
  type        = number
}

# Staging instance setup

variable "staging_instance_type" {
  description = "The type used for the instance"
  type        = string
}

variable "staging_autoscaling_min_size" {
  description = "Minimum size for the autoscaling pool"
  type        = number
}

variable "staging_autoscaling_max_size" {
  description = "Maximum size for the autoscaling pool"
  type        = number
}

variable "staging_autoscaling_desired_capacity" {
  description = "Desired size for the autoscaling pool"
  type        = number
}

# Deployment

variable "deployment_bucket_name" {
  description = "Name of S3 bucket used for deployments"
  type        = string
}

# Domains and certificates

variable "hosted_zone_id" {
  description = "The id of your hosted zone in Route 53"
  type        = string
}

variable "certificate_arn" {
  description = "Wildcard certificate for the top domain"
  type        = string
}

variable "public_storage_certificate_arn" {
  description = "Certificate for public storage"
  type        = string
}

variable "top_domain" {
  description = "The domain name for use with Insights api"
  type        = string
}

variable "subdomain_database" {
  description = "The domain name for use with the database"
  type        = string
}

variable "subdomain_redis" {
  description = "The domain name for use with Redis"
  type        = string
}

variable "subdomain_api" {
  description = "The domain name for use with api"
  type        = string
}

variable "subdomain_insights" {
  description = "The domain name for use with Insights api"
  type        = string
}

variable "subdomain_storage" {
  description = "The domain name for use with public storage"
  type        = string
}

variable "subdomain_staging" {
  description = "The domain name for use by staging"
  type        = string
}

variable "subdomain_insights_staging" {
  description = "The domain name for use by staging"
  type        = string
}

# Storage

variable "public_storage_bucket_name" {
  description = "Name of S3 bucket used for public storage"
  type        = string
}

variable "private_storage_bucket_name" {
  description = "Name of S3 bucket used for private storage"
  type        = string
}

# Database

variable "DATABASE_PASSWORD_PRODUCTION" {
  description = "Name of S3 bucket used for private storage"
  type        = string
}