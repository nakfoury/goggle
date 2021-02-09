# CloudFront requires certificates to be created in us-east-1. This additional provider needs to be
# configured in the root module to use region us-east-1.
provider "aws" {
  alias = "acm"
}

locals {
  website_alternate_domain_names = [
    "www.${var.domain_name}",
  ]
}

# Managed SSL certificate for all CloudFront domains.
resource "aws_acm_certificate" "website" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = local.website_alternate_domain_names

  tags = var.tags

  provider = aws.acm
}

# Create DNS records used by ACM to validate domain ownership.
resource "aws_route53_record" "website_acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.website.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

# All this resource does is wait for ACM DNS validation to succeed.
resource "aws_acm_certificate_validation" "website" {
  certificate_arn         = aws_acm_certificate.website.arn
  validation_record_fqdns = [for record in aws_route53_record.website_acm_validation : record.fqdn]

  provider = aws.acm
}
