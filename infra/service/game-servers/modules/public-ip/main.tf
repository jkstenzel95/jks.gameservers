locals {
    map_clause = var.use_map_in_name ?  "${var.map_name}." : ""
    env_clause = (var.env == "prod") ? "" : "${var.env}."
    domain = lower("${local.env_clause}${var.game_name}.${local.map_clause}${var.dns_name}")
}

data "aws_route53_zone" "main" {
  name = var.dns_name
}

resource "aws_route53_zone" "subdomain_zone" {
  name = local.domain

  tags = {
    Environment = var.env
  }
}

resource "aws_eip" "eip" {
    tags = {
        Name = lower("jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}")
    }
}

resource "aws_route53_record" "game_ns" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = local.domain
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.subdomain_zone.name_servers
}

resource "aws_route53_record" "elastic_ns" {
  zone_id = aws_route53_record.game_ns.zone_id
  name    = local.domain
  type    = "A"
  ttl     = "30"
  records = [ aws_eip.eip.public_ip ]
}