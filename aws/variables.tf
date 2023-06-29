variable "regions" {
  description = "A map of regions where the security groups should be created."
  type        = map(string)
  default     = {
    eu_west_1 = "eu-west-1"
    us_east_1 = "us-east-1"
  }
}
