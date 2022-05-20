# This is the main configuration file. You can deploy your Serverpod by only
# doing changes to this file. However, by default, the configuration uses
# the lowest tier for the database and Redis setup. You will want to edit the
# database.tf and redis.tf files if you need higher performance.

# The name of your project. Used to configure names of resources. In most
# instances you want to set this to the same as your Serverpod project name, but
# avoid any underscores.
# NOTE: the project name cannot use underscore, spaces, or any special
# characters.
project_name = "awsname"

# The region where to deploy the server.
aws_region = "us-west-2"

# Enabling Redis may incur additional costs. You will also need to enable Redis
# in your staging.yaml and production.yaml configuration files.
enable_redis = false

# Domain and certificate used by this Serverpod. You will need to have created a
# public hosted zone in Route 53 and retrieved its id. You will also need to
# manually create a certificate in AWS's Certificate Manager. The certificate
# should cover the top domain and any subdomains. E.g. add example.com and
# *.example.com to your certificate.
hosted_zone_id  = "<YOUR HOSTED ZONE ID>"
top_domain      = "<YOUR DOMAIN NAME>"
certificate_arn = "<YOUR CERTIFICATE ARN>"

# Subdomains for different services. Default values are recommended.
subdomain_database         = "database"
subdomain_redis            = "redis"
subdomain_api              = "api"
subdomain_insights         = "insights"
subdomain_storage          = "storage"
subdomain_staging          = "api-staging"
subdomain_insights_staging = "insights-staging"

# The definition of the server instances to deploy. Note that if you change the
# region, you will have to change the AMI as they are bound to specific regions.
# Serverpod is tested with Amazon Linux 2 Kernel 5.x (You can find the AMI ids
# for a specifc region under EC2 > AMI Catalog in your AWS console.)
instance_type                = "t2.micro"
instance_ami                 = "ami-0ca285d4c2cda3300"
autoscaling_min_size         = 1
autoscaling_max_size         = 1
autoscaling_desired_capacity = 1


# Setup an additional server cluster and associated load balancers for staging.
# By default, the staging server uses the same database and Redis setup as the
# production server. If you want to change this behavior you will need add
# and edit the Terraform files.
enable_staging_server = false

staging_instance_type                = "t2.micro"
staging_autoscaling_min_size         = 1
staging_autoscaling_max_size         = 1
staging_autoscaling_desired_capacity = 1

# The deployment bucket name needs to be unique and can only contain lower case
# letters and dashes (no underscored allowed). Note that you will need to setup
# a specific certificate for the storage that resides in the us-east-1 region.
# E.g. storage.examplepod.com
public_storage_certificate_arn = "<YOUR CERTIFICATE ARN FOR us-east-1>"

deployment_bucket_name      = "awsname-deployment-randomawsid"
public_storage_bucket_name  = "awsname-public-storage-randomawsid"
private_storage_bucket_name = "awsname-private-storage-randomawsid"
