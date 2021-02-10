locals {
  restapi_domain_name = "api.${var.domain_name}"
}

# HTTP API Gateway, which routes traffic to either the website S3 bucket or the RESTAPI Lambda.
resource "aws_apigatewayv2_api" "restapi" {
  name                         = "${var.name}-restapi"
  protocol_type                = "HTTP"
  disable_execute_api_endpoint = true
  tags                         = var.tags
}

# Route all requests to the RESTAPI Lambda function.
resource "aws_apigatewayv2_route" "restapi_default" {
  api_id    = aws_apigatewayv2_api.restapi.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.restapi.id}"
}

# Only one integration is needed -- invoke the RESTAPI Lambda function.
resource "aws_apigatewayv2_integration" "restapi" {
  api_id             = aws_apigatewayv2_api.restapi.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.restapi.invoke_arn
}

resource "aws_apigatewayv2_stage" "restapi" {
  api_id      = aws_apigatewayv2_api.restapi.id
  name        = "$default"
  auto_deploy = true
  tags        = var.tags

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.restapi_access_logs.arn
    format          = local.access_log_format
  }

  default_route_settings {
    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }
}

resource "aws_cloudwatch_log_group" "restapi_access_logs" {
  name              = "${var.name}-restapi-access-logs"
  retention_in_days = 14
  tags              = var.tags
}

# Allows us to use a custom domain with this API Gateway.
resource "aws_apigatewayv2_domain_name" "restapi" {
  domain_name = local.restapi_domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.api.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = var.tags
}

# Maps the custom domain to the API Gateway stage.
resource "aws_apigatewayv2_api_mapping" "restapi" {
  api_id      = aws_apigatewayv2_api.restapi.id
  domain_name = local.restapi_domain_name
  stage       = aws_apigatewayv2_stage.restapi.id
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
