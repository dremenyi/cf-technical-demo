resource "aws_route53_record" "apps_dns" {
  zone_id = data.aws_route53_zone.myzone.id
  name    = var.dns_name
  type    = "A"
  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}