# main.tf

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"
  key_name      = "demo1-key"
  security_groups = [aws_security_group.ec2_security_group.name]
  
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install docker -y
              sudo yum install docker-compose -y
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              EOF
  
  tags = {
    Name = "PrometheusInstance"
  }
}

resource "aws_security_group" "ec2_security_group" {
  name        = "prometheus_security_group"
  description = "Allow SSH, Prometheus, Grafana, and Alertmanager ports"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  tags = {
    Name = "PrometheusSecurityGroup"
  }
}
