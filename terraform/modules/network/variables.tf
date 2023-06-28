variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "VPC name to be used on all the resources as identifier"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name to be used on all the resources as identifier"
  type        = string
}

variable "sg_name" {
  description = "The name of the security group"
  type        = string
}

variable "sg_description" {
  description = "The description of the security group"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC in which to create the security group"
  type        = string
}

variable "ingress_rules" {
  description = "A list of ingress rules"
  type        = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default     = []
}

variable "egress_rules" {
  description = "A list of egress rules"
  type        = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default     = []
}
