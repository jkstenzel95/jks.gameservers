resource "aws_s3_bucket" "bucket" {
  bucket = lower("jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.purpose}-bucket")
  acl    = "private"

  tags = {
    Name        = lower("jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.purpose}-bucket")
    Environment = "${var.env}"
  }
}