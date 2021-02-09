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
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags               = var.tags
}
