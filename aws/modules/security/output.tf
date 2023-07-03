output "sg_id" {
  description = "The IDs of the security groups"
  value       = { for sg in aws_security_group.sg : sg.name => sg.id }
}
