output "alb_dns_name" { 
    value = aws_lb.alb.dns_name 
}
output "alb_zone_id"  { 
    value = aws_lb.alb.zone_id 
}
output "asg_name"     { 
    value = aws_autoscaling_group.asg.name 
}
output "app_sg_id"    { 
    value = aws_security_group.app_sg.id 
}

output "alb_arn_suffix" {
  value = aws_lb.alb.arn_suffix
}
