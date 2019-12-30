# provision-audit-account

Provision `audit-account` with:
* S3 bucket `content` for central logging with archiving to Glacier.
* S3 bucket `access_log` for logging access to `content` S3 bucket.
* KMS key for encryption of CloudTrail events. 

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket_name_for_central_logging | The name of the S3 bucket used for central logging. | string | `audit-account-eu-west-1-log` | no |
| bucket_name_for_access_logs | The name of the S3 bucket used for logging access to bucket `bucket_name_for_central_logging`. | string | `audit-account-eu-west-1-log-access-logs` | no |
| lifecycle_glacier_transition_days | The number of days after object creation when the object is archived into Glacier. | string | `90` | no |
| key_deletion_window_in_days | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days. | string | `10` | no |
| lifecycle_glacier_transition_days | The number of days after object creation when the object is archived into Glacier. | string | `90` | no |
| audit_account_id | The account ID of the `audit-account`account. | string | - | yes |
| region | The region used for the AWS provider. | string | - | yes |
| aws_account_list | The list of AWS accounts that want to send logs to `audit-account`. | list | - | yes |
| terraform_tags | The map of default tags which is used for tagging resources created by this script. | map | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| cloudtrail_kms_key_arn | The ARN of the KMS key used for encrypting CloudTrail events. |
| cloudtrail_kms_key_policy | The policy of the KMS key used for encrypting CloudTrail events. |
| cloudtrail_s3_bucket_name | The name of the S3 bucket used for storing CloudTrail events. |
| cloudtrail_s3_bucket_policy | The bucket policy of the S3 bucket used for storing CloudTrail events. |
