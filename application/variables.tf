# VPC Input Variables

# VPC Name
variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "myvpc"
}

# VPC CIDR Block
variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.1.0.0/16"
}

# VPC Availability Zones
variable "vpc_availability_zones" {
  description = "VPC Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# VPC Public Subnets
variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type        = list(string)
  default     = ["10.1.0.0/24", "10.1.1.0/24"]
}

# VPC Private Subnets
variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type        = list(string)
  default     = ["10.1.2.0/24", "10.1.3.0/24"]
}

# VPC Database Subnets
variable "vpc_database_subnets" {
  description = "VPC Database Subnets"
  type        = list(string)
  default     = ["10.1.4.0/24", "10.1.5.0/24"]
}

# VPC Create Database Subnet Group (True / False)
variable "vpc_create_database_subnet_group" {
  description = "VPC Create Database Subnet Group"
  type        = bool
  default     = true
}

# VPC Create Database Subnet Route Table (True or False)
variable "vpc_create_database_subnet_route_table" {
  description = "VPC Create Database Subnet Route Table"
  type        = bool
  default     = true
}


# VPC Enable NAT Gateway (True or False) 
variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateways for Private Subnets Outbound Communication"
  type        = bool
  default     = true
}

# VPC Single NAT Gateway (True or False)
variable "vpc_single_nat_gateway" {
  description = "Enable two nat's for high availability"
  type        = bool
  default     = false
}

# 
# EC2 Module Variables
#

variable "bastion_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3a.medium"
}

variable "wp_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3a.micro"
}

# AWS EC2 Instance Key Pair
variable "instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance"
  type        = string
  default     = "terraform-key"
}

variable "db_class" {
  type = string
  default = "db.t3.micro"
}

variable "db_engine_version" {
  type = string
  default = "11.15"
}
variable "db_engine" {
  type = string
  default = "postgres"
  
}

variable "db_name" {
  type = string
  default = "RDS1"
}



variable "db_family" {
  type = string
  default = "postgres11"
}

variable "db_major_engine_version" {
  type = string
  default = "11"
}

variable "db_username" {
  type = string
  sensitive = true
  default = "PostgreSql_User"
}

variable "db_password" {
  type = string
  sensitive = true
  default = "PostgreSql_Password" # Would never fly in a production environment
}

variable "dns_name" {
  default = "*.cftechnicaldemo.com"
}




