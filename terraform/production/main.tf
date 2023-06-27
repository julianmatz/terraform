provider "aws" {
  region  = var.region
  profile = var.profile
}

module "db_server" {
  source              = "../modules/ec2_db"
  ami                 = data.aws_ami.debian.id
  instance_type       = "t3.medium"
  subnet_id           = aws_subnet.default.id
  instance_name       = "db_server"
  volume_size         = 20
  security_group_id   = aws_security_group.allow_http_https.id
}

module "ui_server" {
  source              = "../modules/ec2_ui"
  ami                 = data.aws_ami.debian.id
  instance_type       = "t3.micro"
  subnet_id           = aws_subnet.default.id
  instance_name       = "ui_server"
  volume_size         = 10
  security_group_id   = aws_security_group.allow_http_https.id
}
