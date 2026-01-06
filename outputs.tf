output "alb_dns_name" {
  value = module.compute.alb_dns_name
}

output "app_domain" {
  value = var.app_domain_name
}

output "rds_endpoint" {
  value = module.database.db_endpoint
}

output "ssm_note" {
  value = "Instances use AmazonSSMManagedInstanceCore. Use AWS Systems Manager > Fleet Manager or Start Session to connect (no SSH key required)."
}
