locals {
  access_log_format = jsonencode({
    httpMethod     = "$context.httpMethod"
    ip             = "$context.identity.sourceIp"
    protocol       = "$context.protocol"
    requestId      = "$context.requestId"
    requestTime    = "$context.requestTime"
    responseLength = "$context.responseLength"
    routeKey       = "$context.routeKey"
    status         = "$context.status"
  })
}
