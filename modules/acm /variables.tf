variable "domain_name" {
  description = "The domain name for the SSL certificate"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID for DNS validation"
  type        = string
}
