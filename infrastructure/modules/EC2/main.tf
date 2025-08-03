terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "web" {
  name_prefix = "app_api-sg"
  vpc_id      = data.aws_vpc.default.id
  description = "Security group for web servers"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask access"
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
    description = "Postgres access"
  }
  
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name        = "${var.environment}-api-sg"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "ec2-ecr_role" {
  name = "ec2-ecr_role"


  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

}

resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.ec2-ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-ecr-instance-profile"
  role = aws_iam_role.ec2-ecr_role.name
}

resource "aws_instance" "api_app_instance" {
    count = 2
    ami                    = data.aws_ami.amzon_linux.id
    instance_type          = "t2.micro"
    iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
    vpc_security_group_ids = [aws_security_group.web.id]
    subnet_id             = data.aws_subnet.default.id
    key_name               = var.key_name
    user_data = <<-EOF
            #!/bin/bash
            set -e

            # Install Docker
            dnf update -y
            dnf install docker -y
            systemctl enable --now docker
            usermod -aG docker ec2-user

            # Install Docker Compose
            sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose

            # Login to ECR (use instance role credentials)
            REGION="us-east-1"
            ECR_URL="463470967866.dkr.ecr.us-east-1.amazonaws.com"
            aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URL

            # Create docker-compose.yaml
            cat <<EOC > /home/ec2-user/docker-compose.yaml
            services:
              db:
                image: postgres:16
                environment:
                  POSTGRES_USER: myuser
                  POSTGRES_PASSWORD: mypassword
                  POSTGRES_DB: mydb
                volumes:
                 - pgdata:/var/lib/postgresql/data

              web:
                image: omerteomim/api_app:latest
                ports:
                  - "5000:5000"
                depends_on:
                  - db

            volumes:
              pgdata:
            EOC
            chown ec2-user:ec2-user /home/ec2-user/docker-compose.yaml
            cd /home/ec2-user
            sudo -u ec2-user /usr/local/bin/docker-compose up -d
            EOF
    tags = {
        Name        = "${var.environment}-api-server-${count.index + 1}"
        Environment = var.environment
    }
}