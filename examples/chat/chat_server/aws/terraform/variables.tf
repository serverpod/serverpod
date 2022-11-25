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

variable "cloudfront_certificate_arn" {
  description = "Certificate for use with Cloudfront, must be in us-east-1 region."
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

variable "subdomain_web" {
  description = "The domain name for use with the web server"
  type        = string
}

variable "subdomain_storage" {
  description = "The domain name for use with public storage"
  type        = string
}

variable "subdomain_database_staging" {
  description = "The domain name for use with the database"
  type        = string
}

variable "subdomain_redis_staging" {
  description = "The domain name for use with Redis"
  type        = string
}

variable "subdomain_api_staging" {
  description = "The domain name for use by api staging"
  type        = string
}

variable "subdomain_insights_staging" {
  description = "The domain name for use by insights staging"
  type        = string
}

variable "subdomain_web_staging" {
  description = "The domain name for use by web server staging"
  type        = string
}

variable "subdomain_storage_staging" {
  description = "The domain name for use with public storage"
  type        = string
}

variable "use_top_domain_for_web" {
  description = "Set to true if you want to point the top domain to the web server"
  type        = bool
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

variable "public_storage_bucket_name_staging" {
  description = "Name of S3 bucket used for public storage"
  type        = string
}

variable "private_storage_bucket_name_staging" {
  description = "Name of S3 bucket used for private storage"
  type        = string
}

# Database

variable "DATABASE_PASSWORD_PRODUCTION" {
  description = "The production database password, you can find it in the config/passwords.yaml file."
  type        = string
}

variable "DATABASE_PASSWORD_STAGING" {
  description = "The staging database password, you can find it in the config/passwords.yaml file (no need to specify if you aren't deployning a staging environment)."
  type        = string
}