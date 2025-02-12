resource "aws_dynamodb_table" "vpc_records" {
  name         = var.vpc_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "vpc_id"

  attribute {
    name = "vpc_id"
    type = "S"
  }
}
