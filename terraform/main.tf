# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
  name    = "db-web-vpc"
  cidr    = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.2.0/24"]
  enable_nat_gateway = true

  tags = {
    Project = "Terraform-Ansible"
  }
}

# Bastion Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Security Group for Bastion Host"

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

# MySQL Security Group
resource "aws_security_group" "mysql_sg" {
  name        = "mysql-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Security Group for MySQL"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
  }

ingress {
    from_port   = 22
    to_port     = 22
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

# Bastion Host Instance
resource "aws_instance" "bastion_host" {
  ami             = "ami-005fc0f236362e99f"
  instance_type   = "t2.micro"
  key_name        = "jenkins"
  subnet_id       = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "Bastion-Host"
  }
}

# MySQL Instance
resource "aws_instance" "mysql_instance" {
  ami             = "ami-005fc0f236362e99f"
  instance_type   = "t2.micro"
  key_name        = "jenkins"
  subnet_id       = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]

  tags = {
    Name = "MySQL-Instance"
  }
}
