resource "aws_s3_bucket" "bucket" {
  bucket = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.purpose}_bucket"
  acl    = "private"

  tags = {
    Name        = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.purpose}_bucket"
    Environment = "${var.env}"
  }
}