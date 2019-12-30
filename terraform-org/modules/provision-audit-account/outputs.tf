output "cloudtrail_kms_key_arn" {
  description = "The ARN of the KMS key used for encrypting CloudTrail events."
  value       = aws_kms_key.cloudtrail.arn
}

output "cloudtrail_kms_key_policy" {
  description = "The policy of the KMS key used for encrypting CloudTrail events."
  value       = aws_kms_key.cloudtrail.policy
}

output "cloudtrail_s3_bucket_name" {
  description = "The name of the S3 bucket used for storing CloudTrail events."
  value       = aws_s3_bucket.content.bucket
}

output "cloudtrail_s3_bucket_policy" {
  description = "The bucket policy of the S3 bucket used for storing CloudTrail events."
  value       = aws_s3_bucket.content.policy
}
