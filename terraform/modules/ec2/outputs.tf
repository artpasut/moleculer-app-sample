output "arn" {
  description = "The ARN of the instance."
  value       = aws_instance.this.arn
}

output "id" {
  description = "The ID of the instance."
  value       = aws_instance.this.id
}

output "private_dns" {
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC."
  value       = aws_instance.this.private_dns
}

output "security_group_id" {
  description = "ID of the security group associated to this ec2"
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "ARN of the security group associated to this ec2"
  value       = aws_security_group.this.arn
}
