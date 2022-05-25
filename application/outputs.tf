# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# VPC CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# VPC Private Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

# VPC Public Subnets
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# VPC NAT gateway Public IP
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# VPC AZs
output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = module.vpc.azs
}

output "db_subnet_group" {
  description = "The database subnet group"
  value = module.vpc.database_subnet_group
}


#
# Security Group Outputs
#

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.bastion-sg.id
}


output "security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.bastion-sg.name
}

output "zone_id" {
  description = "route 53 hosted zone id"
  value = data.aws_route53_zone.myzone.zone_id
}

output "ec2-wpserver1_private_instance_id" {
  description = "List of IDs of instances"
  value       = module.ec2-wpserver1.id
}
output "ec2-wpserver2_private_instance_id" {
  description = "List of IDs of instances"
  value       = module.ec2-wpserver2.id
}

## ec2_bastion_public_ip
output "ec2_bastion_public_ip" {
  description = "List of public IP addresses assigned to the instances"
  value       = module.ec2-bastion.public_ip 
}
output "ec2-wpserver1_private_ip" {
  description = "List of public IP addresses assigned to the instances"
  value       = module.ec2-wpserver1.private_ip
}
output "ec2-wpserver2_private_ip" {
  description = "List of public IP addresses assigned to the instances"
  value       = module.ec2-wpserver2.private_ip 
}

output "ec2-wpserver2_information" {
  description = "List of public IP addresses assigned to the instances"
  value       = [module.ec2-wpserver2.private_ip, module.ec2-wpserver2.id] 
}

output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = module.acm.acm_certificate_arn
}