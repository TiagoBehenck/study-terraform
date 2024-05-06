terraform {
  required_version = ">=0.13.1"
  required_providers {
    aws = ">=5.47.0"
    local = ">=2.5.1"
  }

  backend "s3" {
    bucket = "terraform"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "new-vpc" {
  source = "./modules/vpc"
  prefix = var.prefix
  vpc_cidr_block = var.vpc_cidr_block
}

module "eks" {
  source = "./modules/eks"
  vpc_id = module.new-vpc.vpc_id
  subnet_ids = module.new-vpc.subnet_ids
  
  prefix = var.prefix
  cluster_name = var.cluster_name
  retention_days = var.retention_days
  desired_size = var.desired_size
  max_size = var.max_size
  min_size = var.min_size
}