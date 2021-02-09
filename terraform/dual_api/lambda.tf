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

  lifecycle {
    ignore_changes = [filename, source_code_hash]
  }
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
