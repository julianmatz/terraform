terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Cirrus-Invicta"

    workspaces {
      name = "terraform"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
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
  source      = "./modules/network"
  vpc_cidr    = "10.0.0.0/16"
  vpc_name    = "terraform-default-vpc"
  subnet_cidr = "10.0.1.0/24"
  subnet_name = "terraform-default-subnet"
}

## SECURITY GROUPS

module "http_https_sg" {
  source = "./modules/security"

  sg_name        = "allow-http-https"
  sg_description = "Allow inbound HTTP and HTTPS traffic"
  vpc_id         = module.network.vpc_id

  ingress_rules = [
    {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "ssh_sg" {
  source = "./modules/security"

  sg_name        = "allow-ssh"
  sg_description = "Allow inbound SSH traffic"
  vpc_id         = module.network.vpc_id

  ingress_rules = [
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

## COMPUTE INSTANCES

/*
module "postgres" {
  source              = "../modules/compute"
  ami                 = data.aws_ami.debian.id
  instance_type       = "t3.medium"
  subnet_id           = aws_subnet.default.id
  instance_name       = "db_server"
  volume_size         = 20
  security_group_id   = aws_security_group.allow_http_https.id
}
*/
module "ui_backend" {
  source              = "./modules/compute"
  ami                 = data.aws_ami.debian.id
  instance_type       = "t3.small"
  subnet_id           = module.network.subnet_id
  instance_name       = "ie-1.ui.lantern.cirrusinvicta.com"
  volume_size         = 10
  security_group_ids  = [module.http_https_sg.sg_id, module.ssh_sg.sg_id]
}

