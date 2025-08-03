output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = aws_instance.api_app_instance[*].id  
}

output "vpc_id" {
  description = "VPC ID where instances are located"
  value       = data.aws_vpc.default.id  
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = data.aws_subnets.default.ids  
}

output "security_group_id" {
  description = "Security group ID of the EC2 instances"
  value       = aws_security_group.web.id  
}
