variable "environment" {
    description = "Environment name"
    type        = string
    default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "AWS Key Pair name"
  type        = string
}