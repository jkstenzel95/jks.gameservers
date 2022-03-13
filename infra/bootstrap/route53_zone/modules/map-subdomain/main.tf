locals {
    envs = ["dev"]
    domain = lower("${var.map_name}.${var.game_name}.${var.domain_name}")
}

resource "aws_route53_zone" "subdomain_zone" {
  name = local.domain
}

resource "aws_route53_record" "ns" {
  zone_id = var.game_zone_id
  name    = local.domain
  type    = "NS"
  ttl     = "30"
  records = var.name_servers
}

module "env_subdomains" {
    source = "./../env-subdomain"
    count = length(local.envs)

    map_zone_id = aws_route53_zone.subdomain_zone.zone_id
    domain_name = var.domain_name
    game_name = var.game_name
    map_name = var.map_name
    env = element(local.envs, count.index)
    name_servers = var.name_servers
}