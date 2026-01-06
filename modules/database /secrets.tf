resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "rds-db-credentials"
  description = "Stores database username and password for MySQL"
}

resource "aws_secretsmanager_secret_version" "db_credentials_value" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "admin"
    password = "jan!2026now"
  })
}
