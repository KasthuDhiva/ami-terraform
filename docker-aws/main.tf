terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.65.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "us-west-2"  # Change to your desired AWS region
}

provider "docker" {
  host = "tcp://${aws_instance.example.public_ip}:2376"  # Access Docker daemon on EC2 instance
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

  provisioner "local-exec" {
    command = "echo 'Waiting for Docker to be ready...'"
  }
}

data "template_file" "docker_config" {
  template = <<-EOF
    [Service]
    ExecStart=
    ExecStart=/usr/bin/dockerd --host=tcp://0.0.0.0:2376
    EOF
}

resource "null_resource" "configure_docker" {
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/docker",
      "echo '${data.template_file.docker_config.rendered}' | sudo tee /etc/docker/daemon.json",
      "sudo systemctl restart docker"
    ]

    connection {
      type        = "ssh"
      host        = aws_instance.example.public_ip
      user        = "ec2-user"
      private_key = file("C:/path/to/jenkins-windows")
    }
  }

  depends_on = [aws_instance.example]
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = "my-nginx-container"
  ports {
    internal = 80
    external = 80
  }
}

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}
