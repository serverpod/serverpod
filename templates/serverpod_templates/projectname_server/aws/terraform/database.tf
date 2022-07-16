resource "aws_db_instance" "postgres" {
  identifier          = var.project_name
  allocated_storage   = 10
  engine              = "postgres"
  engine_version      = "14.2"
  instance_class      = "db.t3.micro"
  db_name             = "serverpod"
  username            = "postgres"
  password            = var.DATABASE_PASSWORD_PRODUCTION
  skip_final_snapshot = true
  vpc_security_group_ids = [
    aws_security_group.database.id
  ]
  publicly_accessible  = true
  db_subnet_group_name = module.vpc.database_subnet_group_name
}

resource "aws_route53_record" "database" {
  zone_id = var.hosted_zone_id
  name    = "${var.subdomain_database}.${var.top_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_db_instance.postgres.address}"]
}

# Makes the database accessible from anywhere.
resource "aws_security_group" "database" {
  name = "${var.project_name}-database"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #   vpc_id = module.vpc.vpc_id
}