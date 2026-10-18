provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.13"

required_providers {
    aws = {
    source  = "hashicorp/aws"
    version = "~> 5.49"
    }
    postgresql = {
    source  = "cyrilgdn/postgresql"
    version = "~> 1.0"
    }
}
}

# provider "postgresql" {
# host            = aws_db_instance.rds-db.address
# port            = aws_db_instance.rds-db.port
# database        = "postgres"
# username        = var.db_username
# password        = var.db_password
# sslmode         = "require"
# depends_on      = [aws_db_instance.rds-db]

# }
