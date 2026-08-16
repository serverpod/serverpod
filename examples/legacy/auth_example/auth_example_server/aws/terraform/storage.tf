# S3 buckets
resource "aws_s3_bucket" "public_storage" {
  bucket        = var.public_storage_bucket_name
  force_destroy = true

  tags = {
    Name = "${var.project_name} public storage"
  }
}

resource "aws_s3_bucket_acl" "public_storage" {
  bucket = aws_s3_bucket.public_storage.id
  acl    = "private"
}

resource "aws_s3_bucket" "private_storage" {
  bucket        = var.private_storage_bucket_name
  force_destroy = true

  tags = {
    Name = "${var.project_name} private storage"
  }
}

resource "aws_s3_bucket_acl" "private_storage" {
  bucket = aws_s3_bucket.private_storage.id
  acl    = "private"
}

locals {
  s3_origin_id = "${var.project_name}-storage"
}

resource "aws_cloudfront_distribution" "public_storage" {
  origin {
    origin_id   = local.s3_origin_id
    domain_name = aws_s3_bucket.public_storage.bucket_regional_domain_name
  }
  enabled = true

  aliases = ["${var.subdomain_storage}.${var.top_domain}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn = var.cloudfront_certificate_arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_route53_record" "public_storage" {
  zone_id = var.hosted_zone_id
  name    = "${var.subdomain_storage}.${var.top_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_cloudfront_distribution.public_storage.domain_name}"]
}