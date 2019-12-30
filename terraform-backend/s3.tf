resource "aws_kms_key" "s3_terraform_state_key" {
  description = "This key is used to encrypt objects in terraform_state S3 bucket"
  tags        = local.terraform_tags

  deletion_window_in_days = 10

  policy = file("${path.module}/s3-bucket-policy.json")
}

resource "aws_kms_alias" "s3_terraform_state_key_alias" {
  name          = "alias/${local.tfstate_bucket_name}-key"
  target_key_id = aws_kms_key.s3_terraform_state_key.key_id
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = local.tfstate_bucket_name
  acl    = "private"

  tags   = local.terraform_tags
  region = var.region

  lifecycle {
    prevent_destroy = "true"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.s3_terraform_state_key.arn
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "state"
    prefix  = "state/"
    enabled = true

    noncurrent_version_expiration {
      days = 90
    }
  }
}
