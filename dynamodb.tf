resource "aws_dynamodb_table" "news_table" {
  name           = "NewsTable"
  hash_key       = "news_id"
  range_key      = "timestamp"
  billing_mode   = "PAY_PER_REQUEST"  # On-demand capacity
  attribute {
    name = "news_id"
    type = "S"
  }
  attribute {
    name = "timestamp"
    type = "S"
  }
  global_secondary_index {
    name               = "TimestampIndex"
    hash_key           = "timestamp"
    projection_type    = "ALL"
  }
}

