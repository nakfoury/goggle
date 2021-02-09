output "website_s3_bucket" {
  description = "Name of the S3 bucket for hosting the website static content."
  value       = module.dual_api.website_s3_bucket
}

output "restapi_lambda" {
  description = "Name of the AWS Lambda for the REST API code."
  value       = module.dual_api.restapi_lambda
}

output "wsapi_lambda" {
  description = "Name of the AWS Lambda for the websocket API code."
  value       = module.dual_api.wsapi_lambda
}

output "website_domain_name" {
  description = "Domain name for the website."
  value       = module.dual_api.website_domain_name
}

output "wsapi_domain_name" {
  description = "Domain name for the websocket API."
  value       = module.dual_api.wsapi_domain_name
}

output "restapi_domain_name" {
  description = "Domain name for the REST API."
  value       = module.dual_api.restapi_domain_name
}
