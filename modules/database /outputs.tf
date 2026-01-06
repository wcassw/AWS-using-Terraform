output "db_endpoint" {
  value = aws_db_instance.mysql.address
}

output "db_identifier" {
  value = aws_db_instance.mysql.id
}

output "db_secret_arn" {
  description = "ARN of the RDS credentials secret"
  value       = aws_secretsmanager_secret.db_credentials.arn
}
