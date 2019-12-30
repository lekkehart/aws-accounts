resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${local.tfstate_bucket_name}-lock"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }

  tags   = local.terraform_tags
}
