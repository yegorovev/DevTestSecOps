output "instance_id" {
  description = "ID of the EC2 instance t2.micro"
  value       = aws_instance.test-t2-micro.id
}