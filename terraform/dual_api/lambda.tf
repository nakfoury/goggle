# Lambda function that handles all REST API requests.
# The source code is managed externally.
resource "aws_lambda_function" "restapi" {
  function_name    = "${var.name}-restapi"
  handler          = "restapi"
  role             = aws_iam_role.backend.arn
  runtime          = "go1.x"
  filename         = "${path.module}/dummy_files/restapi.zip"
  source_code_hash = filebase64sha256("${path.module}/dummy_files/restapi.zip")
  tags             = var.tags

  lifecycle {
    ignore_changes = [filename, source_code_hash]
  }
}

resource "aws_cloudwatch_log_group" "restapi" {
  name              = "/aws/lambda/${aws_lambda_function.restapi.function_name}"
  retention_in_days = 14
  tags              = var.tags
}

# Lambda function that handles all Websocket API requests.
# The source code is managed externally.
resource "aws_lambda_function" "wsapi" {
  function_name    = "${var.name}-wsapi"
  handler          = "wsapi"
  role             = aws_iam_role.backend.arn
  runtime          = "go1.x"
  filename         = "${path.module}/dummy_files/wsapi.zip"
  source_code_hash = filebase64sha256("${path.module}/dummy_files/wsapi.zip")
  tags             = var.tags

  environment {
    variables = {
      API_GATEWAY_INVOKE_URL = "https://${local.wsapi_domain_name}"
    }
  }

  lifecycle {
    ignore_changes = [filename, source_code_hash]
  }
}

resource "aws_cloudwatch_log_group" "wsapi" {
  name              = "/aws/lambda/${aws_lambda_function.wsapi.function_name}"
  retention_in_days = 14
  tags              = var.tags
}

# Backend IAM role for both Lambda functions.
resource "aws_iam_role" "backend" {
  name               = "${var.name}-backend"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# Backend IAM policy for both Lambda functions.
resource "aws_iam_policy" "backend" {
  name   = "${var.name}-restapi"
  policy = data.aws_iam_policy_document.backend.json
}

# Define permissions for the Lambda functions here.
data "aws_iam_policy_document" "backend" {
  statement {
    sid = "CloudWatchLogs"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "${aws_cloudwatch_log_group.restapi.arn}/*",
      "${aws_cloudwatch_log_group.wsapi.arn}/*",
    ]
  }

  statement {
    sid       = "APIGatewayManagement"
    actions   = ["execute-api:ManageConnections"]
    resources = ["${aws_apigatewayv2_api.wsapi.execution_arn}/*"]
  }
}

# Attach the backend policy to the role.
resource "aws_iam_role_policy_attachment" "backend" {
  role       = aws_iam_role.backend.name
  policy_arn = aws_iam_policy.backend.arn
}

# Give RESTAPI API Gateway permission to invoke the RESTAPI lambda.
resource "aws_lambda_permission" "restapi" {
  statement_id  = "APIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.restapi.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.restapi.execution_arn}/*/*"
}

# Give the WSAPI API Gateway permission to invoke the WSAPI lambda.
resource "aws_lambda_permission" "wsapi" {
  statement_id  = "APIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.wsapi.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.wsapi.execution_arn}/*/*"
}
