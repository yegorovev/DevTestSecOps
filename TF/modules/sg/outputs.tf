# TODO Maybe or not concatenate all outputs
output "sg_id" {
  description = "ID security group"
  value       = aws_security_group.sg.id
}

output "sgr_id" {
  description = "ID security group rule"
  value       = aws_security_group_rule.rules[*].id
}
