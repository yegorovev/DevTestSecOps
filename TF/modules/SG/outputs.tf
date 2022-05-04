# TODO Maybe or not concatenate all outputs
output "sg_id" {
  description = "ID security group"
  value       = aws_security_group.sg.id
}
