# Outputs for the Compute Module
output "compute_instance_id" {
  description = "The ID of the instance"
  value       = module.ui_backend.instance_id
}

output "compute_public_ip" {
  description = "The public IP address assigned to the instance"
  value       = module.ui_backend.public_ip
}

# Outputs for the Network Module
output "network_vpc_id" {
  description = "The ID of the VPC"
  value       = module.network.vpc_id
}

output "network_subnet_id" {
  description = "The ID of the subnet"
  value       = module.network.subnet_id
}

# Outputs for the Security Module
output "security_sg_id_http_https" {
  description = "The ID of the HTTP/HTTPS security group"
  value       = module.http_https_sg.sg_id
}

output "security_sg_id_ssh" {
  description = "The ID of the SSH security group"
  value       = module.ssh_sg.sg_id
}

