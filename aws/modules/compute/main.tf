terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.6.2"
    }
  }
}

resource "aws_instance" "default" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = var.volume_size
    volume_type = "gp3"
    throughput  = var.throughput
  }

  tags = {
    Name        = var.instance_name
    Environment = var.environment
    Roles       = var.roles
  }

  lifecycle {
    prevent_destroy = false
  }

  vpc_security_group_ids = var.security_group_ids
}

resource "aws_eip" "eip" {
  count = var.create_eip ? 1 : 0
  vpc   = true

  tags = {
    Name = "${var.instance_name}-eip"
  }
}

resource "aws_eip_association" "eip_assoc" {
  count         = var.create_eip ? 1 : 0
  instance_id   = aws_instance.default.id
  allocation_id = aws_eip.eip[0].id
}
