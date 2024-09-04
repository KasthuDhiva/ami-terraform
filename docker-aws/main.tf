terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.65.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "ap-south-1"  # Change to your desired AWS region
}

resource "aws_instance" "example" {
  ami           = "terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.65.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "ap-south-1"  # Change to your desired AWS region
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Update with the latest Amazon Linux 2 AMI ID for your region
  instance_type = "t2.micro"  # Choose instance type based on your requirements
  key_name       = "jenkins-windows"  # SSH key pair name

  tags = {
    Name = "docker-instance"
  }

  # Add a user data script to install Docker
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              usermod -a -G docker ec2-user
              EOF
}

resource "aws_ami_from_instance" "docker_ami" {
  name               = "docker-ami"
  source_instance_id = aws_instance.example.id
  description        = "AMI with Docker installed"

  tags = {
    Name = "docker-ami"
  }
}

output "ami_id" {
  value = aws_ami_from_instance.docker_ami.id
}
"  # Update with the latest Amazon Linux 2 AMI ID for your region
  instance_type = "t2.micro"  # Choose instance type based on your requirements
  key_name       = "jenkins-windows"  # SSH key pair name

  tags = {
    Name = "docker-instance"
  }

  # Add a user data script to install Docker
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              usermod -a -G docker ec2-user
              EOF
}

resource "aws_ami_from_instance" "docker_ami" {
  name               = "docker-ami"
  source_instance_id = aws_instance.example.id
  description        = "AMI with Docker installed"

  tags = {
    Name = "docker-ami"
  }
}

output "ami_id" {
  value = aws_ami_from_instance.docker_ami.id
}
