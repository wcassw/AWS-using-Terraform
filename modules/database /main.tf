# DB security group — allow MySQL only from app SG
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "allows mysql from app"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_sg_id]
  }
  egress { 
    from_port = 0 
    to_port = 0 
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
    }

  tags = { Name = "db-sg" }
}

resource "aws_db_subnet_group" "db_subnets" {
  name       = "db-subnet-group"
  subnet_ids = var.db_subnet_ids
  tags       = { Name = "db-subnet-group" }
}

resource "aws_db_instance" "mysql" {
  identifier             = var.db_identifier
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.instance_cls
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  db_name                = var.db_name
  # Fetch credentials from Secrets Manager
  username = jsondecode(aws_secretsmanager_secret_version.db_credentials_value.secret_string)["username"]
  password = jsondecode(aws_secretsmanager_secret_version.db_credentials_value.secret_string)["password"]

  multi_az               = true
  publicly_accessible    = false
  storage_type           = "gp3"
  skip_final_snapshot    = true
  deletion_protection    = false

  backup_retention_period = 7

  tags = { Name = "mysql-rds" }
}
