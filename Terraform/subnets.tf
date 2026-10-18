resource "aws_subnet" "private_subnet_1" {
  vpc_id = aws_vpc.vpc.id

  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.project_name}-private-${var.aws_region}a"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.vpc.id

  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "${var.project_name}-private-${var.aws_region}b"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.vpc.id

  cidr_block = "10.0.3.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-${var.aws_region}a"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.vpc.id

  cidr_block = "10.0.4.0/24"
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.project_name}-public-${var.aws_region}b"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_db_subnet_group" "rds-subnet-group" {
  name       = "rds-private-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Name = "RDS Private Subnet Group"
  }
}
