module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  #version = "2.14.0"
  version = "3.0.0"

  domain_name  = trimsuffix(data.aws_route53_zone.myzone.name, ".")
  zone_id      = data.aws_route53_zone.myzone.zone_id 

  subject_alternative_names = [
    #"*.devopsincloud.com"
    var.dns_name 
  ]
}
