# Shared backend state configuration.
terraform {
  backend "s3" {
    bucket  = "flame-zinger-tf"
    key     = "goggle/terraform.tfstate"
    region  = "us-west-2"
    profile = "goggle"
  }
}

# AWS authentication settings.
provider "aws" {
  region  = "us-west-2"
  profile = "goggle"
}

# Alternate AWS authentication settings, for us-east-1 resources.
provider "aws" {
  alias   = "acm"
  region  = "us-east-1"
  profile = "goggle"
}

# Locals are reusable static variables.
locals {
  name = "goggle"
  tags = {
    project = local.name
  }
  domain_name = "freewordgame.com"
}

# Misc persistent data bucket for the backend.
resource "aws_s3_bucket" "data" {
  bucket = "${local.name}-data"
  tags   = local.tags
}

# Lookup the zone by domain name to get the zone ID.
data "aws_route53_zone" "this" {
  name = local.domain_name
}

# The dual_api module encapsulates resources for a generic website + REST API + websocket API.
#
# The website will be created on the root domain of the specified Route53 zone. The REST API will
# be on an "api" subdomain. The websocket API will be on a "ws" subdomain.
module "dual_api" {
  source      = "./dual_api"
  name        = local.name
  domain_name = local.domain_name
  zone_id     = data.aws_route53_zone.this.zone_id
  tags        = local.tags

  providers = {
    aws.acm = aws.acm
  }
}

resource "aws_dynamodb_table" "this" {
  name           = "goggle"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "RoomCode"

  attribute {
    name = "RoomCode"
    type = "S"
  }
}
