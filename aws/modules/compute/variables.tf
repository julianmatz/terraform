variable "ami" {
  description = "The ID of the AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to associate with the instance"
  type        = string
}

variable "key_name" {
  description = "The key pair name for SSH access"
  type        = string
  default     = "devops"
}

variable "volume_size" {
  description = "The size of the EBS volume in gigabytes"
  type        = number
  default     = 8 # default is 8 GB, but this should be adjusted based on your needs
}

variable "throughput" {
  description = "The throughput to provision for a gp3 volume (in MiB/s)"
  type        = number
  default     = 125
}

variable "prevent_destroy" {
  description = "Whether to prevent the instance from being destroyed"
  type        = bool
  default     = false
}

variable "instance_name" {
  description = "The name to assign to the instance"
  type        = string
}

variable "environment" {
  description = "The environment where infrastructure is deployed"
  type        = string
  default     = "production"
}

variable "roles" {
  description = "The roles associated with the instance"
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "List of IDs of the security groups to associate with the instance"
  type        = list(string)
}

variable "create_eip" {
  description = "Whether to create an EIP for this instance"
  type        = bool
  default     = false
}
