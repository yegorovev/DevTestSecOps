# TODO Maybe or not concatenate all outputs
output "application_ids" {
  description = "ID of the EC2 application instance"
  value       = aws_instance.application.id
}

output "private_ip" {
  description = "private_ip of the EC2 application instance"
  value       = aws_instance.application.private_ip
}

output "public_ip" {
  description = "public_ip of the EC2 application instance"
  value       = aws_instance.application.public_ip
}
