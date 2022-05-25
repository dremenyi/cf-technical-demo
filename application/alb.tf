/*
resource "aws_lb" "application_lb" {
  name               = "Application-LB"
  internal           = false
  load_balancer_type = "application"
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  security_groups    = [aws_security_group.alb_sg.id]

  # Change to true once TF testing is complete
  enable_deletion_protection = false
}

resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-FS-1-2-2019-08"
  #certificate_arn   = aws_acm_certificate.public_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wp_server.arn
  }
}

resource "aws_lb_target_group" "wp_server" {
  name     = "wpserver1-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_target_group_attachment" "wpserver1" {
  target_group_arn = aws_lb_target_group.wp_server.arn
  target_id        = aws_instance.ec2-wpserver1.id
  port             = 80
}
*/
# Terraform AWS Application Load Balancer (ALB)
module "alb" {
  source = "terraform-aws-modules/alb/aws"
  #version = "5.16.0"
  version = "6.0.0"

  name               = "cftechnical-alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]
  # Listeners
  # HTTP Listener - HTTP to HTTPS Redirect
  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]
  # Target Groups
  target_groups = [
    # App1 Target Group - TG Index = 0
    {
      name_prefix          = "app1-"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      # App1 Target Group - Targets
      targets = {
        my_app1_vm1 = {
          target_id = module.ec2-wpserver1.id[0]
          port      = 80
        },
        my_app1_vm2 = {
          target_id = module.ec2-wpserver2.id[0]
          port      = 80
        }
      }
    },
  ]

  # HTTPS Listener
  https_listeners = [
    # HTTPS Listener Index = 0 for HTTPS 443
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = module.acm.acm_certificate_arn
      action_type     = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed Static message - for Root Context"
        status_code  = "200"
      }
    },
  ]

  # HTTPS Listener Rules
  https_listener_rules = [
    # Rule-1: /app1* should go to App1 EC2 Instances
    {
      https_listener_index = 0
      priority             = 1
      actions = [
        {
          type               = "forward"
          target_group_index = 0
        }
      ]
      conditions = [{
        path_patterns = ["/*"]
      }]
    },
  ]
}



