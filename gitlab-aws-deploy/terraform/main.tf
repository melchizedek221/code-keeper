
provider "aws" {
  region = "us-east-1"
}

# resource "aws_key_pair" "gitlab_key" {
#   key_name   = "gitlab-key"
#   public_key = file("~/.ssh/gitlab.pub")
# }

resource "aws_security_group" "gitlab_sg" {
  name        = "gitlab_sg"
  description = "Allow SSH, HTTP, and HTTPS"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Données pour récupérer l'AMI Ubuntu la plus récente
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "gitlab" {
  ami                    = data.aws_ami.ubuntu.id  #"ami-0c02fb55956c7d316" #ubunut 22 to use ami-084568db4383264d4
  instance_type          = "t3a.large"
  key_name               = "gitlab-key"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.gitlab_sg.id]

  tags = {
    Name = "GitLab-Server"
  }
}

output "public_ip" {
  value = aws_instance.gitlab.public_ip
}

# Crée un VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

# Crée un subnet public dans ce VPC
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"  # adapte selon ta zone

  tags = {
    Name = "public-subnet"
  }
}

# Crée une Internet Gateway et l’attache au VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-igw"
  }
}

# Crée une route table associée au VPC
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-rt"
  }
}

# Ajoute une route vers l'Internet Gateway pour tout le trafic
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associe la route table au subnet public
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
