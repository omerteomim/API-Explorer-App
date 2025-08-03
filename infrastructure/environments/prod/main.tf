terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "omer-state-tf"
    key    = "api_app/prod/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

module "ECR" {
  source = "../../modules/ECR"
  environment = var.environment
  aws_region  = var.aws_region
}