locals {
    envs = ["dev"]
    domain = lower("${var.map_name}.${var.game_name}.${var.domain_name}")
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

module "env_subdomains" {
    source = "./../env-subdomain"
    count = length(local.envs)

    main_zone_id = var.main_zone_id
    domain_name = var.domain_name
    game_name = var.game_name
    map_name = var.map_name
    env = element(local.envs, count.index)
    name_servers = var.name_servers
}