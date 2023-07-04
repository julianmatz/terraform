resource "aws_eip" "eip" {
  domain = vpc
  tags = {
    Name = var.eip_name
  }
}
