locals {
    domain = lower("${var.env}.${var.map_name}.${var.game_name}.${var.domain_name}")
}

resource "aws_route53_zone" "subdomain_zone" {
  name = local.domain
}

resource "aws_route53_record" "ns" {
  zone_id = var.main_zone_id
  name    = local.domain
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.subdomain_zone.name_servers
}