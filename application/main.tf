#
# LOCALS
#
locals {
  user_data = <<EOF
  #!/bin/bash
  yum update -y
  yum install -y httpd.x86_64
  systemctl start httpd.service
  systemctl enable httpd.service
  echo "#CrushedTheTechnical from $(hostname -f)" > /var/www/html/index.html
  EOF
}




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
  database_subnets                   = var.vpc_database_subnets
  create_database_subnet_group       = var.vpc_create_database_subnet_group
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table


  # NAT Gateways - Outbound Communication
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

##
# Security Group Module
##


######
# EC2 Module
######

## Root volume is set to 50. Change later if time
module "ec2-bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.17.0"
  # insert the 10 required variables here
  name                   = "bastion1"
  ami                    = data.aws_ami.latest_winserv_ami.id
  instance_type          = var.bastion_instance_type
  key_name               = "technical-key"
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  subnet_id              = module.vpc.public_subnets[0]

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 500
      volume_size = 50
    },
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}

module "ec2-wpserver1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.17.0"
  # insert the 10 required variables here
  name                   = "wpserver2"
  ami                    = data.aws_ami.latest_redhat_ami.id
  instance_type          = var.wp_instance_type
  key_name               = "technical-key"
  vpc_security_group_ids = [aws_security_group.rh_sg.id]
  subnet_id              = module.vpc.private_subnets[0]
  user_data_base64       = base64encode(local.user_data)

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 20
    },
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}

module "ec2-wpserver2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.17.0"
  # Inserting the required variables here
  name                   = "wpserver2"
  ami                    = data.aws_ami.latest_redhat_ami.id
  instance_type          = var.wp_instance_type
  key_name               = "technical-key"
  vpc_security_group_ids = [aws_security_group.rh_sg.id]
  subnet_id              = module.vpc.private_subnets[1]
  user_data_base64       = base64encode(local.user_data)

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 20
    },
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}

