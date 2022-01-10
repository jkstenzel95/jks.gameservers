resource "aws_dynamodb_table" "game_key_value_store" {
  name             = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-kv_table"
  hash_key         = "Key"

  attribute {
    name = "Key"
    type = "S"
  }

  attribute {
    name = "Value"
    type = "S"
  }

  replica {
    region_name = "us-east-2"
  }

  replica {
    region_name = "us-west-2"
  }
}