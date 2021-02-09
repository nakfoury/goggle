# Bucket for the statically hosted website files. The files are managed externally.
resource "aws_s3_bucket" "website" {
  bucket = var.domain_name
}

# TODO: CloudFormation resource
