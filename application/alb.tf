resource "aws_lb" "application_lb" {
  name               = "Application-LB"
  internal           = false
  load_balancer_type = "application"
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  security_groups    = [aws_security_group.alb_sg.id] ## TODO: create custom ALB SG

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
/*
resource "aws_lb_target_group_attachment" "wpserver1" {
  target_group_arn = aws_lb_target_group.wp_server.arn
  target_id        = aws_instance.ec2-wpserver1.id
  port             = 80
}
*/