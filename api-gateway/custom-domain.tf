resource "aws_api_gateway_domain_name" "domain_name" {
  count           = var.use-custom-domain == true ? 1 : 0
  domain_name     = var.custom-domain-name
  certificate_arn = data.aws_acm_certificate.custom_domain.arn
}

resource "aws_route53_record" "custom_domain_dns" {
  name    = aws_api_gateway_domain_name.domain_name.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.custom_domain_zone.id
  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.domain_name.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.domain_name.cloudfront_zone_id
  }
}
