output "website_s3_bucket" {
  description = "Name of the S3 bucket for hosting the website static content."
  value       = aws_s3_bucket.website.bucket
}

output "restapi_lambda" {
  description = "Name of the AWS Lambda for the REST API code."
  value       = aws_lambda_function.restapi.function_name
}

output "wsapi_lambda" {
  description = "Name of the AWS Lambda for the websocket API code."
  value       = aws_lambda_function.wsapi.function_name
}

output "website_domain_name" {
  description = "Domain name for the website."
  value       = var.domain_name
}

output "wsapi_domain_name" {
  description = "Domain name for the websocket API."
  value       = local.wsapi_domain_name
}

output "restapi_domain_name" {
  description = "Domain name for the REST API."
  value       = local.restapi_domain_name
}
