variable "name" {
  description = "Unique name prefix for resources."
  type        = string
}

variable "domain_name" {
  description = "Base domain name. Must be in the provided zone_id."
  type        = string
}

variable "zone_id" {
  description = "Route53 hosted zone ID."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
}
