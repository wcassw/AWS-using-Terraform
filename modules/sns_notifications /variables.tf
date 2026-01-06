variable "sns_topic_name" {
  description = "Name of the SNS topic for notifications"
  type        = string
}

variable "asg_name" {
  description = "Auto Scaling Group name for event notifications"
  type        = string
}

variable "notification_email" {
  description = "Email for SNS alerts"
  type        = string
}
