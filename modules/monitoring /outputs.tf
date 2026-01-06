output "scaling_policy_name" { 
    value = aws_autoscaling_policy.tt_cpu.name 
}

output "alarm_names" {
  value = [
    aws_cloudwatch_metric_alarm.asg_high_cpu.alarm_name,
    aws_cloudwatch_metric_alarm.alb_5xx_errors.alarm_name,
    aws_cloudwatch_metric_alarm.rds_low_storage.alarm_name
  ]
}
