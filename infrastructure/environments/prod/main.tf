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

module "EC2" {
    source = "../../modules/EC2"
    environment = var.environment
    key_name =var.key_name
}

module "ALB" {
  source           = "../../modules/ALB"
  environment      = var.environment
  instance_ids     = module.EC2.instance_ids
  vpc_id           = module.EC2.vpc_id
  subnet_ids       = module.EC2.subnet_ids
  security_group_id = module.EC2.security_group_id
}