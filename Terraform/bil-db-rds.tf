# RDS Instance
resource "aws_db_instance" "bill-db" {
  identifier               = "billing-db"
  db_name                  = "billing_db"
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
  final_snapshot_identifier = "bill-db-final-snapshot"
  
  # Enhanced monitoring and backup settings
  monitoring_interval                = 60
  monitoring_role_arn               = aws_iam_role.rds_monitoring_role.arn
  enabled_cloudwatch_logs_exports   = ["postgresql", "upgrade"]
  backup_retention_period           = 7
  backup_window                     = "03:00-04:00"
  maintenance_window               = "Mon:04:00-Mon:05:00"
  
  # Performance insights
  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  # Protection settings
  deletion_protection = false
  multi_az           = false  # Set to true for production

  tags = {
    Name        = "bill-db"
    Environment = "production"
    Managed_by  = "terraform"
  }
}
