output "instance_id" {
  description = "The ID of the instance"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "The public IP address assigned to the instance"
  value       = aws_instance.main.public_ip
}
