# Code assumes that you have your enviornment variables set for authentication
terraform {
  required_version = ">= 0.13.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }
  }
  backend "s3" {
    bucket = "terraform-three-tier-demo-dakota"
    key    = "application/terraform.tfstate"
    region = "us-east-1"
  }
}
provider "aws" {
  region = "us-east-1"
}