resource "aws_dynamodb_table" "game_key_value_store" {
  name             = "jks-gs-${var.env}-${var.region_shortname}-${var.game_name}-${var.map_name}-kv_table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key         = "Key"
  lifecycle {
    prevent_destroy = true
  }

  attribute {
    name = "Key"
    type = "S"
  }

  replica {
    region_name = "us-east-2"
  }

  replica {
    region_name = "us-west-2"
  }
}