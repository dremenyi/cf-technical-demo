###############################
# Data Sources for EC2 Module #
###############################
data "aws_ami" "latest_redhat_ami" {
  most_recent = true
  owners      = ["309956199498"] #Needs changed for GovCloud
  filter {
    name   = "name"
    values = ["RHEL-8*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "latest_winserv_ami" {
  most_recent = true
  owners      = ["801119661308"] #Needs changed for GovCloud
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

data "aws_route53_zone" "myzone" {
  name         = "cftechnicaldemo.com"
}