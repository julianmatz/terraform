terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.6.2"
    }
  }
}

resource "aws_security_group" "sg" {
  for_each = var.sg_rules

  name        = each.key
  description = "Security Group for ${each.key}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = each.value
    content {
      description      = ingress.value["description"]
      from_port        = ingress.value["from_port"]
      to_port          = ingress.value["to_port"]
      protocol         = ingress.value["protocol"]
      cidr_blocks      = ingress.value["cidr_blocks"]
      ipv6_cidr_blocks = ingress.value["ipv6_cidr_blocks"]
      prefix_list_ids  = ingress.value["prefix_list_ids"]
    }
  }
}
