# Set up and configure Terraform and the Google Cloud provider.
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("credentials.json")

  project = var.project
  region  = var.region
  zone    = var.zone
}

# Add a Serverpod module configured for production. Full documentation on all
# options is available at:
# https://github.com/serverpod/terraform-google-serverpod-cloud-engine

module "serverpod_production" {
  # References the Serverpod module from GitHub.
  source = "github.com/serverpod/terraform-google-serverpod-cloud-engine?ref=stable-1.1"

  # Required parameters.
  project               = var.project
  service_account_email = var.service_account_email

  runmode = "production"

  region = var.region
  zone   = var.zone

  dns_managed_zone = var.dns_managed_zone
  top_domain       = var.top_domain

  # Size of the auto scaling group.
  autoscaling_min_size = 1
  autoscaling_max_size = 2

  # Password for the production database.
  database_password = var.DATABASE_PASSWORD_PRODUCTION

  # Adds Cloud Storage buckets for file uploads.
  enable_storage = true

  # Adds Redis for caching and communication between servers.
  enable_redis = false

  # Makes it possible to SSH into the individual server instances.
  enable_ssh = true
}


# If you want to set up a staging environment, you can add a second module
# configured for staging. Just uncomment the following code and change the
# parameters as needed (default options should work too).

# module "serverpod_staging" {
#   # References the Serverpod module from GitHub.
#   source = "github.com/serverpod/terraform-google-serverpod-cloud-engine?ref=stable-1.1"

#   # Required parameters.
#   project               = var.project
#   service_account_email = var.service_account_email

#   runmode = "staging"

#   region = var.region
#   zone   = var.zone

#   dns_managed_zone = var.dns_managed_zone
#   top_domain       = var.top_domain

#   # Prefix for the staging, added to all subdomains.
#   subdomain_prefix = "staging-"

#   # Size of the auto scaling group.
#   autoscaling_min_size = 1
#   autoscaling_max_size = 2

#   # Password for the production database.
#   database_password = var.DATABASE_PASSWORD_STAGING

#   # Adds Cloud Storage buckets for file uploads.
#   enable_storage = true

#   # Adds Redis for caching and communication between servers.
#   enable_redis = false

#   # Makes it possible to SSH into the individual server instances.
#   enable_ssh = true
# }
