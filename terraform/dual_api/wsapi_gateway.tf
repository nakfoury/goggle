locals {
  wsapi_domain_name = "ws.${var.domain_name}"
}

# Websocket API Gateway, which handles websocket messages and invokes the WSAPI Lambda.
resource "aws_apigatewayv2_api" "wsapi" {
  name                         = "${var.name}-wsapi"
  protocol_type                = "WEBSOCKET"
  disable_execute_api_endpoint = true
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
  api_id             = aws_apigatewayv2_api.wsapi.id
  integration_type   = "AWS"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.wsapi.invoke_arn
}

resource "aws_apigatewayv2_stage" "wsapi" {
  api_id      = aws_apigatewayv2_api.wsapi.id
  name        = "prod"
  auto_deploy = true
  tags        = var.tags
}

# Allows us to use a custom domain with this API Gateway.
resource "aws_apigatewayv2_domain_name" "wsapi" {
  domain_name = local.wsapi_domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.this.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = var.tags
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
