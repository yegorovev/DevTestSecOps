output "key" {
  description = "ID aws key pair"
  value       = aws_key_pair.ec2-key.id
}

output "application_id" {
  description = "ID of the EC2 application instance"
  value       = { for i, app in module.application : i => app.application_id }
}

output "private_ip" {
  description = "private_ip of the EC2 application instance"
  value       = { for app in module.application : app.application_id => app.private_ip }
}

output "public_ip" {
  description = "public_ip of the EC2 application instance"
  value       = { for app in module.application : app.application_id => app.public_ip }
}

output "security_group_id" {
  description = "ID security group"
  value       = module.sg[*].sg_id
}

output "security_group_rule_id" {
  description = "ID security group rule"
  value       = module.sg[*].sgr_id
}
