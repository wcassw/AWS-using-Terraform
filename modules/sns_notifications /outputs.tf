output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "sns_subscription_status" {
  value = "Check your email (${var.notification_email}) and confirm the subscription to start receiving notifications."
}
