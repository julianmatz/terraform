terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.5.0"
    }
  }
}

provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"
}

## DATA

data "aws_ami" "debian" {
  most_recent = true
  owners      = ["136693071363"] # https://wiki.debian.org/Cloud/AmazonEC2Image/Bullseye

  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }
}

## NETWORKS

module "network" {
  source       = "../modules/network"
  vpc_cidr     = "10.0.0.0/16"
  vpc_name     = "terraform-default-vpc"
  subnet_cidr  = "10.0.1.0/24"
  subnet_name  = "terraform-default-subnet"
}

## COMPUTE INSTANCES

module "postgres" {
  source              = "../modules/ec2_db"
  ami                 = data.aws_ami.debian.id
  instance_type       = "t3.medium"
  subnet_id           = aws_subnet.default.id
  instance_name       = "db_server"
  volume_size         = 20
  security_group_id   = aws_security_group.allow_http_https.id
}

module "ui_backend" {
  source              = "../modules/ec2_ui"
  ami                 = data.aws_ami.debian.id
  instance_type       = "t3.micro"
  subnet_id           = aws_subnet.default.id
  instance_name       = "ui_server"
  volume_size         = 10
  security_group_id   = aws_security_group.allow_http_https.id
}
