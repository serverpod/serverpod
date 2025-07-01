resource "aws_elasticache_cluster" "redis" {
  count = var.enable_redis ? 1 : 0

  cluster_id         = var.project_name
  engine             = "redis"
  node_type          = "cache.t4g.micro"
  num_cache_nodes    = 1
  engine_version     = "6.x"
  port               = 6379
  apply_immediately  = true
  security_group_ids = [aws_security_group.redis[0].id]
  subnet_group_name  = aws_elasticache_subnet_group.redis[0].name
}

resource "aws_route53_record" "redis" {
  count = var.enable_redis ? 1 : 0

  zone_id = var.hosted_zone_id
  name    = "${var.subdomain_redis}.${var.top_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_elasticache_cluster.redis[0].cache_nodes[0].address}"]
}

# Makes Redis accessible from the serverpod only.
resource "aws_security_group" "redis" {
  count = var.enable_redis ? 1 : 0

  name = "${var.project_name}-redis"
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.serverpod.id]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_elasticache_subnet_group" "redis" {
  count = var.enable_redis ? 1 : 0

  name       = "${var.project_name}-subnet"
  subnet_ids = module.vpc.public_subnets
}

# Staging
resource "aws_elasticache_cluster" "redis_staging" {
  count = var.enable_redis && var.enable_staging_server ? 1 : 0

  cluster_id         = var.project_name
  engine             = "redis"
  node_type          = "cache.t4g.micro"
  num_cache_nodes    = 1
  engine_version     = "6.x"
  port               = 6379
  apply_immediately  = true
  security_group_ids = [aws_security_group.redis[0].id]
  subnet_group_name  = aws_elasticache_subnet_group.redis[0].name
}

resource "aws_route53_record" "redis_staging" {
  count = var.enable_redis && var.enable_staging_server ? 1 : 0

  zone_id = var.hosted_zone_id
  name    = "${var.subdomain_redis_staging}.${var.top_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_elasticache_cluster.redis_staging[0].cache_nodes[0].address}"]
}