variable "asg_name" { 
    type = string 
}
variable "target_cpu_utilization" { 
    type = number 
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for CloudWatch alarms"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ARN suffix of the Application Load Balancer for CloudWatch alarms"
  type        = string
}

variable "db_identifier" {
  description = "RDS database identifier for CloudWatch alarms"
  type        = string
}
