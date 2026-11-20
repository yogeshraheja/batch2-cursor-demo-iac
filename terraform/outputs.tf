output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.yogesh_demo.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.yogesh_demo.public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.yogesh_demo.private_ip
}
