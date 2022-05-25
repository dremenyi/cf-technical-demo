###########
# LOCALS  #
###########
locals {
  user_data = <<EOF
  #!/bin/bash
  sudo yum update -y
  sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
  sudo dnf install httpd
  sudo systemctl start httpd
  sudo systemctl enable httpd
  sudo firewall-cmd --zone=public --permanent --add-service=http
  sudo firewall-cmd --reload
  sudo echo '<h1>#Test- APP-1</h1>' | sudo tee /var/www/html/index.html
  sudo mkdir /var/www/html/app1
  sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>#Test- APP-1</h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
  echo "#CrushedTheTechnical from $(hostname -f)" > /var/www/html/index.html
  sudo curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app1/metadata.html
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
  name                   = "wpserver1"
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
