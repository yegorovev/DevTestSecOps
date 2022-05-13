output "instance_profile_name" {
  description = "IAM instance profile name"
  value       = aws_iam_instance_profile.profile.name
}

output "role_id" {
  description = "IAM role ID"
  value       = aws_iam_role.role.id
}