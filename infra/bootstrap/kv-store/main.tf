resource "aws_dynamodb_table" "game_key_value_store" {
  name              = "jks-gs-${var.env}-${var.region_shortname}-kv_table"
  billing_mode      = "PAY_PER_REQUEST"
  stream_enabled    = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  hash_key          = "Key"

  attribute {
    name = "Key"
    type = "S"
  }

  replica {
    region_name = "us-east-1"
  }

  replica {
    region_name = "us-west-2"
  }
}