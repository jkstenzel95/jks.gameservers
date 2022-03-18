local {
  map_clause = (var.map_name != "") ? "${var.map_name}-" : "" 
}

resource "aws_s3_bucket" "bucket" {
  bucket = lower("jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${local.map_clause}${var.purpose}-bucket")
  acl    = "private"
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = lower("jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.purpose}-bucket")
    Environment = "${var.env}"
  }
}