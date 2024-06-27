data "aws_ssm_parameter" "kurs_omega_domain" {
  name = "kurs_omega_domen"
}

data "aws_ssm_parameter" "kurs_omega_subdomain" {
  name = "kurs_omega_subdomen"
}

data "aws_route53_zone" "hosted_zone" {
  name = data.aws_ssm_parameter.kurs_omega_domain.value
}

module "acm" {
  source              = "terraform-aws-modules/acm/aws"
  domain_name         = data.aws_ssm_parameter.kurs_omega_subdomain.value
  zone_id             = data.aws_route53_zone.hosted_zone.zone_id
  validation_method   = "DNS"
  wait_for_validation = true
  dns_ttl             = 60
  tags                = var.all_tags
}