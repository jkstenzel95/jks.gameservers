resource "aws_eip" "eip" {
    tags = {
        Name = lower("jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}")
    }
}

/* resource "aws_route53_record" "www" {
    zone_id = ""
    name = ""
    type = ""
} */