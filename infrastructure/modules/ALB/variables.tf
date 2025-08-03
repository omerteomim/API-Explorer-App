variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instance_ids" {
  description = "List of EC2 instance IDs to attach to the load balancer"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID of the EC2 instances"
  type        = string
}

variable "health_check_path" {
  description = "Health check path for the target group"
  type        = string
  default     = "/"
}