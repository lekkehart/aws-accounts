# ------------------------------------------------------------
# Outputs from module create-accounts
# ------------------------------------------------------------
output "aws_accounts" {
  description = "The map of AWS account names/numbers."
  value       = module.create-accounts.aws_accounts
}

# ------------------------------------------------------------
# Outputs from module provision-audit-account
# ------------------------------------------------------------
output "audit_cloudtrail_kms_key_arn" {
  description = "The ARN of the KMS key used for encrypting CloudTrail events."
  value       = module.provision-audit-account.cloudtrail_kms_key_arn
}

output "cloudtrail_s3_bucket_name" {
  description = "The name of the S3 bucket used for storing CloudTrail events."
  value       = module.provision-audit-account.cloudtrail_s3_bucket_name
}

