# RDS Instance
resource "aws_db_instance" "rds-db" {
  identifier               = "inventory-db"
  db_name                  = "inventory_db"
  engine                   = "postgres"
  engine_version           = "16.3"
  allocated_storage        = 20
  storage_type             = "gp2"
  instance_class           = "db.t3.micro"
  publicly_accessible      = true
  username                 = var.db_username
  password                 = var.db_password
  parameter_group_name     = aws_db_parameter_group.custom_pg.name
  db_subnet_group_name     = aws_db_subnet_group.rds-subnet-group.name
  vpc_security_group_ids   = [aws_security_group.rds.id]
  skip_final_snapshot      = true
  final_snapshot_identifier = "inventory-db-final-snapshot"
  
  # Enhanced monitoring and backup settings
  monitoring_interval                = 60
  monitoring_role_arn               = aws_iam_role.rds_monitoring_role.arn
  enabled_cloudwatch_logs_exports   = ["postgresql", "upgrade"]
  backup_retention_period           = 0
  
  # Performance insights
  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  # Protection settings
  deletion_protection = false
  multi_az           = false  # Set to true for production

  # Activation du chiffrement
  storage_encrypted    = true
  # kms_key_id           = aws_kms_key.rds_kms_key.arn
  tags = {
    Name        = "inventory-db"
    Environment = "production"
    Managed_by  = "terraform"
  }
}

# Parameter Group
resource "aws_db_parameter_group" "custom_pg" {
  name        = "custom-postgres16"
  family      = "postgres16"
  description = "Custom parameter group for PostgreSQL 16"

  parameter {
  name         = "log_min_duration_statement"
  value        = "1000"
  apply_method = "immediate"
  }

  parameter {
  name         = "log_statement"
  value        = "all"
  apply_method = "immediate"
  }

  parameter {
  name         = "max_connections"
  value        = "100"
  apply_method = "pending-reboot"
  }

  parameter {
  name         = "shared_buffers"
  value        = "{DBInstanceClassMemory/32768}"
  apply_method = "pending-reboot"
  }

  parameter {
  name         = "work_mem"
  value        = "4096"
  apply_method = "pending-reboot"
  }

  parameter {
  name         = "maintenance_work_mem"
  value        = "65536"
  apply_method = "pending-reboot"
  }

  tags = {
    Name = "custom-postgres-parameters"
  }
}

# Security Group
resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Allow access to RDS from EKS"
  vpc_id      = aws_vpc.vpc.id

  ingress {
  description = "PostgreSQL access - combined rule"
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0", "154.124.183.190/32"]  # Warning: Consider restricting in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "rds-security-group"
  }
}

# IAM Role for Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring_role" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_policy" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# Output the connection string
output "db_uri" {
  value = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.rds-db.endpoint}/${aws_db_instance.rds-db.db_name}"
  sensitive = true
}

# Output additional useful information
output "rds_hostname" {
  value = aws_db_instance.rds-db.address
}

output "rds_port" {
  value = aws_db_instance.rds-db.port
}

output "rds_database_name" {
  value = aws_db_instance.rds-db.db_name
}
