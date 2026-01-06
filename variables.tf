variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "az1" {
  description = "First Availability Zone (e.g., us-east-1a)"
  type        = string
}

variable "az2" {
  description = "Second Availability Zone (e.g., us-east-1b)"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

# Public subnets (one per AZ)
variable "public_subnet_az1_cidr" { 
    type = string 
}
variable "public_subnet_az2_cidr" { 
    type = string 
}

# Private subnets (two per AZ)
variable "private1_az1_cidr" { 
    type = string 
} 
variable "private2_az1_cidr" { 
    type = string 
} 
variable "private1_az2_cidr" { 
    type = string 
} 
variable "private2_az2_cidr" { 
    type = string 
} 

# Compute/ASG
variable "app_ami_id" {
  description = "Amazon Linux 2 AMI ID (supply explicitly)"
  type        = string
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "asg_min"     { 
    type = number 
    default = 2 
}
variable "asg_desired" { 
    type = number 
    default = 2 
}
variable "asg_max"     { 
    type = number 
    default = 4 
}

# RDS
variable "db_name"     { 
    type = string 
    default = "appdb" 
}
variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_identifier" {
  default = "terraform-3tier-db"
}

# Route53
variable "route53_hosted_zone_id" {
  description = "Hosted Zone ID for your domain"
  type        = string
}
variable "app_domain_name" {
  description = "Route 53 registered domain"
  type        = string
}

# CloudWatch scaling target (CPU%)
variable "target_cpu_utilization" {
  type    = number
  default = 50
}

variable "notification_email" {
  description = "Email for SNS alerts"
  type        = string
}
