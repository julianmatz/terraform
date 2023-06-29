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
  alias  = "eu_west_1"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
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

locals {
  vpc_cidrs = {
    eu_west_1 = "10.0.0.0/16"
    us_east_1 = "10.1.0.0/16"
    // add additional regions and their respective CIDRs here...
  }
  subnet_cidrs = {
    eu_west_1 = "10.0.1.0/24"
    us_east_1 = "10.1.1.0/24"
    // add additional regions and their respective CIDRs here...
  }
}

resource "aws_vpc" "vpc" {
  for_each = local.vpc_cidrs

  providers  = { aws[each.key] }
  cidr_block = each.value
  tags = {
    Name = "terraform-default-vpc-${each.key}"
  }
}

resource "aws_subnet" "subnet" {
  for_each = local.subnet_cidrs

  providers  = { aws[each.key] }
  vpc_id     = aws_vpc.vpc[each.key].id
  cidr_block = each.value

  tags = {
    Name = "terraform-subnet-${each.key}"
  }
}

## SECURITY GROUPS

module "http_https_sg" {
  source   = "./modules/security"
  for_each = var.regions

  providers = {
    aws = aws[each.key]
  }

  sg_name        = "allow-http-https"
  sg_description = "Allow inbound HTTP and HTTPS traffic"
  vpc_id         = output.vpc_ids[each.key]

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
  source   = "./modules/security"
  for_each = var.regions

  providers = {
    aws = aws[each.key]
  }

  sg_name        = "allow-ssh"
  sg_description = "Allow inbound SSH traffic"
  vpc_id         = output.vpc_ids[each.key]

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
module "ui_backend_ie1" {
  source             = "./modules/compute"
  providers          = { aws = aws.eu_west_1 }
  ami                = data.aws_ami.debian.id
  instance_type      = "t3.small"
  subnet_id          = aws_subnet.subnet[eu_west_1].id
  instance_name      = "ie-1.ui.lantern.cirrusinvicta.com"
  volume_size        = 10
  security_group_ids = [module.http_https_sg[eu_west_1].sg_id, module.ssh_sg[eu_west_1].sg_id]
  create_eip         = true
}
