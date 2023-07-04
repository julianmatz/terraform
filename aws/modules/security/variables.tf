variable "vpc_id" {
  description = "The ID of the VPC in which to create the security group"
  type        = string
}

variable "sg_rules" {
  description = "A map of security group rules"
  type = map(list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    prefix_list_ids  = list(string)
  })))
}

