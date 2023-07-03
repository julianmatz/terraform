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
      version = "5.6.2"
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

resource "aws_vpc" "eu_west_1" {
  providers  = { aws = aws.eu_west_1 }
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_subnet" "eu_west_1" {
  providers  = { aws = aws.eu_west_1 }
  vpc_id     = aws_vpc.eu_west_1.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "terraform-subnet-1"
  }
}

resource "aws_vpc" "us_east_1" {
  providers  = { aws = aws.us_east_1 }
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_subnet" "us_east_1" {
  providers  = { aws = aws.us_east_1 }
  vpc_id     = aws_vpc.us_east_1.id
  cidr_block = "10.1.1.0/24"
  tags = {
    Name = "terraform-subnet-1"
  }
}

## SECURITY GROUPS

module "security_group_eu_west_1" {
  source    = "./modules/security"
  providers = { aws = aws.eu_west_1 }

  vpc_id   = aws_vpc.vpc_eu_west_1.id
  sg_rules = var.sg_rules
}

module "security_group_us_east_1" {
  source    = "./modules/security"
  providers = { aws = aws.us_east_1 }

  vpc_id   = aws_vpc.vpc_us_east_1.id
  sg_rules = var.sg_rules
}

# Use security_group_eu_west_1.sg_id and security_group_us_east_1.sg_id 
# wherever the security group ID is needed for other resources in the respective regions.


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
  security_group_ids = [module.security_group_eu_west_1.sg_id["ssh"], module.security_group_eu_west_1.sg_id["http_https"]]
  create_eip         = true
}
