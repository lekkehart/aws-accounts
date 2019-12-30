# ------------------------------------------------------------
# KMS Key to encrypt CloudTrail events.
# The policy was derived from the default key policy descrived in AWS CloudTrail User Guide.
# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/default-cmk-policy.html
# ------------------------------------------------------------
data "template_file" "kms_policy_conditions_template" {
  template = file("${path.module}/templates/kms-policy-condition.tpl")
  count = length(var.aws_account_list)

  vars = {
    account_id = var.aws_account_list[count.index]
  }
}

resource "aws_kms_key" "cloudtrail" {
  description             = "A KMS key to encrypt CloudTrail events."
  tags = var.terraform_tags

  deletion_window_in_days = var.key_deletion_window_in_days
  enable_key_rotation     = "true"

  policy = <<END_OF_POLICY
{
    "Version": "2012-10-17",
    "Id": "Key policy created by CloudTrail",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {"AWS": [
                "arn:aws:iam::${var.audit_account_id}:root"
            ]},
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow CloudTrail to encrypt logs",
            "Effect": "Allow",
            "Principal": {"Service": ["cloudtrail.amazonaws.com"]},
            "Action": "kms:GenerateDataKey*",
            "Resource": "*",
            "Condition": {"StringLike": {"kms:EncryptionContext:aws:cloudtrail:arn": [ ${join(",", data.template_file.kms_policy_conditions_template.*.rendered)} ]}}
        }
    ]
}
END_OF_POLICY
}

resource "aws_kms_alias" "cloudtrail" {
  name          = "alias/ekklot_audit_cloudtrail"
  target_key_id = aws_kms_key.cloudtrail.key_id
}

# ------------------------------------------------------------
# Create a S3 bucket to store various audit logs.
# Bucket policies are derived from the default bucket policy described in
# AWS Config Developer Guide and AWS CloudTrail User Guide.
# https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-policy.html
# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/create-s3-bucket-policy-for-cloudtrail.html
# ------------------------------------------------------------
resource "aws_s3_bucket" "access_log" {
  bucket = var.bucket_name_for_access_logs
  tags = var.terraform_tags

  acl = "log-delivery-write"

  lifecycle_rule {
    id      = "auto-archive"
    enabled = true

    prefix = "/"

    transition {
      days          = var.lifecycle_glacier_transition_days
      storage_class = "GLACIER"
    }
  }
}

data "template_file" "bucket_policy_resources_template_for_cloudtrail" {
  template = file("${path.module}/templates/bucket-policy-resource-for-cloudtrail.tpl")
  count = length(var.aws_account_list)

  vars = {
    bucket_name = var.bucket_name_for_central_logging
    account_id = var.aws_account_list[count.index]
  }
}

data "template_file" "bucket_policy_resources_template_for_config" {
  template = file("${path.module}/templates/bucket-policy-resource-for-config.tpl")
  count = length(var.aws_account_list)

  vars = {
    bucket_name = var.bucket_name_for_central_logging
    account_id = var.aws_account_list[count.index]
  }
}

resource "aws_s3_bucket" "content" {
  bucket = var.bucket_name_for_central_logging
  tags = var.terraform_tags

  acl = "private"

  logging {
    target_bucket = aws_s3_bucket.access_log.id
  }

  versioning {
    enabled = true

    # Temporarily disabled due to Terraform issue.
    # https://github.com/terraform-providers/terraform-provider-aws/issues/629
    # mfa_delete = true
  }

  lifecycle_rule {
    id      = "auto-archive"
    enabled = true

    prefix = "/"

    transition {
      days          = var.lifecycle_glacier_transition_days
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      days          = var.lifecycle_glacier_transition_days
      storage_class = "GLACIER"
    }
  }

  policy = <<END_OF_POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.bucket_name_for_central_logging}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:PutObject",
            "Resource": [ ${join(",", data.template_file.bucket_policy_resources_template_for_cloudtrail.*.rendered)} ],
            "Condition": {"StringEquals": {"s3:x-amz-acl": "bucket-owner-full-control"}}
        },
        {
            "Sid": "AWSConfigAclCheck",
            "Effect": "Allow",
            "Principal": {"Service": "config.amazonaws.com"},
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.bucket_name_for_central_logging}"
        },
        {
            "Sid": " AWSConfigWrite",
            "Effect": "Allow",
            "Principal": {"Service": "config.amazonaws.com"},
            "Action": "s3:PutObject",
            "Resource": [ ${join(",", data.template_file.bucket_policy_resources_template_for_config.*.rendered)} ],
            "Condition": {"StringEquals": {"s3:x-amz-acl": "bucket-owner-full-control"}}
        }
    ]
}
END_OF_POLICY
}
