variable "regions" {
  description = "A map of regions where the security groups should be created."
  type        = map(string)
  default = {
    eu_west_1 = "eu-west-1"
    us_east_1 = "us-east-1"
  }
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

