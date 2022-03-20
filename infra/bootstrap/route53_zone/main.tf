locals {
  games = ["ark", "mc", "valheim"]
}

resource "aws_route53_zone" "main" {
  name = var.domain_name
}

module "game_subdomains" {
    source = "./modules/game-subdomain"
    count = length(local.games)

    main_zone_id = aws_route53_zone.main.zone_id
    domain_name = var.domain_name
    game_name = element(local.games, count.index)
    name_servers = aws_route53_zone.main.name_servers
}