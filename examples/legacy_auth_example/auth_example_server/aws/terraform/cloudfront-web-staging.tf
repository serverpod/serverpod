locals {
  alb_origin_id_staging = "${var.project_name}-web-staging"
}

resource "aws_cloudfront_distribution" "web_staging" {
  count = var.enable_staging_server ? 1 : 0

  origin {
    origin_id   = local.alb_origin_id_staging
    domain_name = aws_lb.serverpod_staging[0].dns_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["SSLv3"]
    }
  }
  enabled = true

  aliases = ["${var.subdomain_web_staging}.${var.top_domain}"]

  default_cache_behavior {
    allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = local.alb_origin_id_staging

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }

      headers = ["*"]
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
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

resource "aws_route53_record" "web_staging" {
  count = var.enable_staging_server ? 1 : 0

  zone_id = var.hosted_zone_id
  name    = "${var.subdomain_web_staging}.${var.top_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_cloudfront_distribution.web_staging[0].domain_name}"]
}