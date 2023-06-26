terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.5.0"
    }
  }
}

provider "aws" {
  alias = "eu-west-1"
  region = "eu-west-1"
}

data "aws_ami" "debian" {
  most_recent = true
  owners      = ["136693071363"] # https://wiki.debian.org/Cloud/AmazonEC2Image/Bullseye

  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "default" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_instance" "test" {
    provider = aws.eu-west-1
    ami = data.aws_ami.debian.id
    instance_type = "t3.micro"
    subnet_id     = aws_subnet.default.id
    tags = {
        Name = "test"
    }

  ebs_block_device {
    device_name = "/dev/xvdf"
    volume_type = "gp3"
    volume_size = 10
  }

  vpc_security_group_ids = [aws_security_group.allow_http_https.id]
}

resource "aws_security_group" "allow_http_https" {
  name        = "allow_http_https"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
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
