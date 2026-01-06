variable "vpc_id" { 
    type = string 
}

variable "private_subnet_ids_for_asg" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "app_ami_id"   { 
    type = string 
}
variable "instance_type"{ 
    type = string 
}
variable "asg_min"      { 
    type = number 
}
variable "asg_desired"  { 
    type = number 
}
variable "asg_max"      { 
    type = number 
}

variable "db_secret_arn" {
  description = "ARN of the RDS secret in Secrets Manager"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM SSL certificate"
  type        = string
}
