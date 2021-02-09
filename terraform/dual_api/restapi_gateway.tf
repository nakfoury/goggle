locals {
  restapi_domain_name = "api.${var.domain_name}"
}

# HTTP API Gateway, which routes traffic to either the website S3 bucket or the RESTAPI Lambda.
resource "aws_apigatewayv2_api" "restapi" {
  name                         = "${var.name}-restapi"
  protocol_type                = "HTTP"
  target                       = aws_lambda_function.restapi.arn
  disable_execute_api_endpoint = true
  tags                         = var.tags
}

# Allows us to use a custom domain with this API Gateway.
resource "aws_apigatewayv2_domain_name" "restapi" {
  domain_name = local.restapi_domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.this.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = var.tags
}

# Create an A record for the domain, which routes to the HTTP API Gateway, for website and RESTAPI
# requests.
resource "aws_route53_record" "restapi" {
  name    = local.restapi_domain_name
  type    = "A"
  zone_id = var.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.restapi.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.restapi.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
