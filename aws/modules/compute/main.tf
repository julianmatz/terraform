resource "aws_instance" "default" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = var.storage_size
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
}

resource "aws_instance" "persistent" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = var.storage_size
    volume_type = "gp3"
    throughput  = var.throughput
  }

  tags = {
    Name        = var.instance_name
    Environment = var.environment
    Roles       = var.roles
  }

  lifecycle {
    prevent_destroy = true
  }
}
