terraform {
  backend "s3" {
    bucket  = "flame-zinger-tf"
    key     = "goggle/terraform.tfstate"
    region  = "us-west-2"
    profile = "goggle"
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "goggle"
}

provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  profile = "goggle"
}

resource "aws_s3_bucket" "data" {
  bucket = "goggle-data"
}

resource "aws_lambda_function" "restapi" {
  function_name = "goggleRESTAPI"
  handler       = "restapi"
  role          = aws_iam_role.backend.arn
  runtime       = "go1.x"

  lifecycle {
    ignore_changes = [filename, source_code_hash]
  }
}

resource "aws_lambda_function" "wsapi" {
  function_name = "goggleWSAPI"
  handler       = "wsapi"
  role          = aws_iam_role.backend.arn
  runtime       = "go1.x"

  lifecycle {
    ignore_changes = [filename, source_code_hash]
  }
}

resource "aws_iam_role" "backend" {
  name               = "goggle-backend"
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
}
