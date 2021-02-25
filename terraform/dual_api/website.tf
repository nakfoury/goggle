# Bucket for the statically hosted website files. The files are managed externally.
resource "aws_s3_bucket" "website" {
  bucket = var.domain_name
  tags   = var.tags
}

# The S3 bucket is private and only allows CloudFront to access it.
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website_bucket_policy.json
}

data "aws_iam_policy_document" "website_bucket_policy" {
  statement {
    sid = "CloudFrontReadAccess"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.website.iam_arn]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]
  }
}

# Block all public access to the bucket, since all access will be via CloudFront, which the bucket
# policy takes care of.
resource "aws_s3_bucket_public_access_block" "website" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

locals {
  website_domain_names = concat(local.website_alternate_domain_names, [var.domain_name])
}

# The CloudFront distribution sits in front of the S3 bucket to serve static web content. The
# primary for using it instead of an API Gateway is so that we can upgrade http traffic to https,
# which API Gateway does not support.
resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  aliases             = local.website_domain_names
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  tags                = var.tags

  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = "S3Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.website.arn
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }
}

# Creates an IAM user for the CloudFront distribution, which it will use when requesting objects
# from S3.
resource "aws_cloudfront_origin_access_identity" "website" {}

# Create DNS routes for the main domain and any subdomain aliases (www.*).
resource "aws_route53_record" "website" {
  for_each = aws_cloudfront_distribution.website.aliases

  name    = each.value
  type    = "A"
  zone_id = var.zone_id

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}
