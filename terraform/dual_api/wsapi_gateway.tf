locals {
  wsapi_domain_name = "ws.${var.domain_name}"
}

# Websocket API Gateway, which handles websocket messages and invokes the WSAPI Lambda.
resource "aws_apigatewayv2_api" "wsapi" {
  name                         = "${var.name}-wsapi"
  protocol_type                = "WEBSOCKET"
  disable_execute_api_endpoint = true
  route_selection_expression   = "$request.body.action"
  tags                         = var.tags
}

# Set up required websocket routes. All of them route to the WSAPI Lambda integration.

resource "aws_apigatewayv2_route" "wsapi_connect" {
  api_id    = aws_apigatewayv2_api.wsapi.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.wsapi.id}"
}

resource "aws_apigatewayv2_route" "wsapi_disconnect" {
  api_id    = aws_apigatewayv2_api.wsapi.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.wsapi.id}"
}

resource "aws_apigatewayv2_route" "wsapi_default" {
  api_id    = aws_apigatewayv2_api.wsapi.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.wsapi.id}"
}

# Only one integration is needed -- invoke the WSAPI Lambda function.
resource "aws_apigatewayv2_integration" "wsapi" {
  api_id           = aws_apigatewayv2_api.wsapi.id
  integration_type = "AWS_PROXY"
  #  integration_method = "POST"
  integration_uri = aws_lambda_function.wsapi.invoke_arn
}

resource "aws_apigatewayv2_stage" "wsapi" {
  api_id      = aws_apigatewayv2_api.wsapi.id
  name        = "$default"
  auto_deploy = true
  tags        = var.tags

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.wsapi_access_logs.arn
    format          = local.access_log_format
  }

  default_route_settings {
    logging_level = "INFO"

    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }
}

resource "aws_cloudwatch_log_group" "wsapi_access_logs" {
  name              = "${var.name}-wsapi-access-logs"
  retention_in_days = 14
  tags              = var.tags
}

# Allows us to use a custom domain with this API Gateway.
resource "aws_apigatewayv2_domain_name" "wsapi" {
  domain_name = local.wsapi_domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.api.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = var.tags
}

# Maps the custom domain to the API Gateway stage.
resource "aws_apigatewayv2_api_mapping" "wsapi" {
  api_id      = aws_apigatewayv2_api.wsapi.id
  domain_name = local.wsapi_domain_name
  stage       = aws_apigatewayv2_stage.wsapi.id
}

# Create a separate A record under a subdomain, which routes to the Websocket API Gateway.
resource "aws_route53_record" "wsapi" {
  name    = local.wsapi_domain_name
  type    = "A"
  zone_id = var.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.wsapi.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.wsapi.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
