# Managed SSL certificate for all API Gateway custom domains.
resource "aws_acm_certificate" "api" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    local.wsapi_domain_name,
    local.restapi_domain_name,
  ]

  tags = var.tags
}

# Create DNS records used by ACM to validate domain ownership.
resource "aws_route53_record" "api_acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.api.domain_validation_options : dvo.domain_name => {
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
resource "aws_acm_certificate_validation" "api" {
  certificate_arn         = aws_acm_certificate.api.arn
  validation_record_fqdns = [for record in aws_route53_record.api_acm_validation : record.fqdn]
}
