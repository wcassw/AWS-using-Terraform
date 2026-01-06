# Create SNS topic
resource "aws_sns_topic" "alerts" {
  name = var.sns_topic_name
  tags = { Name = var.sns_topic_name }
}

# Subscribe an email address
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# Enable Auto Scaling notifications
resource "aws_autoscaling_notification" "asg_alerts" {
  group_names = [var.asg_name]
  topic_arn   = aws_sns_topic.alerts.arn

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]
}
