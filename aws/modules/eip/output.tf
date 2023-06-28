output "eip_id" {
  description = "The ID of the Elastic IP address"
  value       = aws_eip.eip.id
}

output "eip_public_ip" {
  description = "The public IP address assigned to the Elastic IP"
  value       = aws_eip.eip.public_ip
}
