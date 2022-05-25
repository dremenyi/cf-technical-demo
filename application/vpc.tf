

# Create VPC Terraform Module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  #version = "2.78.0"
  version = "3.0.0"

  # VPC Basic Details
  #name = "test-name"
  cidr            = var.vpc_cidr_block
  azs             = var.vpc_availability_zones
  public_subnets  = var.vpc_public_subnets
  private_subnets = var.vpc_private_subnets

  # Database Subnets
  # create databse route table will not associate the same route table as other private `
  # subnets that have a NAT Gateway `
  # This ensures that the databases will not communicate outbound via NAT. `
  # No other route table exists that would allow Internet communication with the databases either
  database_subnets                   = var.vpc_database_subnets
  create_database_subnet_group       = var.vpc_create_database_subnet_group
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table


  # NAT Gateways - Outbound Communication
  # Variable is set to false for high availability
  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true


  # Additional Tags to Subnets

  vpc_tags = {
    Name        = "cf-technical-vpc"
    Type        = "Public Subnets"
    Project     = "Technical"
    Environment = "Test"
    Owner       = "Dakota Remenyi"
  }

  public_subnet_tags = {
    Name        = "cf-technical-public"
    Type        = "Public Subnets"
    Project     = "Technical"
    Environment = "Test"
    Owner       = "Dakota Remenyi"
  }
  private_subnet_tags = {
    Name        = "cf-technical-private"
    Type        = "Private Subnets"
    Project     = "Technical"
    Environment = "Test"
    Owner       = "Dakota Remenyi"
  }
  database_subnet_tags = {
    Name        = "cf-technical-privateDB"
    Type        = "Private Database Subnets"
    Project     = "Technical"
    Environment = "Test"
    Owner       = "Dakota Remenyi"
  }
}





