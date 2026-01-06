# Target tracking scaling policy (CloudWatch monitors ASG average CPU)
resource "aws_autoscaling_policy" "tt_cpu" {
  name                   = "asg-tt-cpu"
  autoscaling_group_name = var.asg_name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.target_cpu_utilization
  }
}

# CLOUDWATCH ALARMS → SNS NOTIFICATIONS

# High CPU utilization alarm
resource "aws_cloudwatch_metric_alarm" "asg_high_cpu" {
  alarm_name          = "ASG-HighCPU"
  alarm_description   = "Alert when average CPU utilization > 70% for 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  treat_missing_data  = "missing"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [var.sns_topic_arn]
  ok_actions    = [var.sns_topic_arn]
}


# ALB 5xx error alarm
resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "ALB-5xxErrors"
  alarm_description   = "Alert when ALB 5xx error count exceeds 10 in 5 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_actions = [var.sns_topic_arn]
  ok_actions    = [var.sns_topic_arn]
}


# RDS free storage alarm
resource "aws_cloudwatch_metric_alarm" "rds_low_storage" {
  alarm_name          = "RDS-LowStorage"
  alarm_description   = "Alert when RDS free storage space < 1 GB"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 1000000000  # 1 GB in bytes
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = var.db_identifier
  }

  alarm_actions = [var.sns_topic_arn]
  ok_actions    = [var.sns_topic_arn]
}
