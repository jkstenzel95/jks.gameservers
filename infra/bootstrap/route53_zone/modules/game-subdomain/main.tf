locals {
    ark_mapsets = [ "all" ]
    minecraft_maps = [ "main" ]
    maps = var.game_name == "ark" ? local.ark_mapsets : ( var.game_name == "minecraft" ? local.minecraft_maps : [] )
    domain = lower("${var.game_name}.${var.domain_name}")
}

resource "aws_route53_zone" "subdomain_zone" {
  name = local.domain
}

resource "aws_route53_record" "ns" {
  zone_id = var.main_zone_id
  name    = local.domain
  type    = "NS"
  ttl     = "30"
  records = var.name_servers
}

module "map_subdomains" {
    source = "./../map-subdomain"
    count = length(local.maps)

    game_zone_id = aws_route53_zone.subdomain_zone.zone_id
    domain_name = var.domain_name
    game_name = var.game_name
    map_name = element(local.maps, count.index)
    name_servers = var.name_servers
}