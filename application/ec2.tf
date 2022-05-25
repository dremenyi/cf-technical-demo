###########
# LOCALS  #
###########
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


module "ec2-bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.17.0"
  depends_on = [
    module.vpc
  ]
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
  depends_on = [
    module.vpc
  ]
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
  depends_on = [
    module.vpc
  ]
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
