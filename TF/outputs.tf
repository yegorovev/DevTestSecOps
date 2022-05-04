output "application_id" {
  description = "ID of the EC2 application instance"
  value       = module.application[*].application_id
}

output "private_ip" {
  description = "private_ip of the EC2 application instance"
  value       = module.application[*].private_ip
}

output "public_ip" {
  description = "public_ip of the EC2 application instance"
  value       = module.application[*].public_ip
}

output "sg_id" {
  description = "public_ip of the EC2 application instance"
  value       = module.sg[*].sg_id
}
