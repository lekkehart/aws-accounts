variable "bucket_name_for_central_logging" {
  description = "The name of the S3 bucket used for central logging."
  default = "audit-account-eu-west-1-log"
}
variable "bucket_name_for_access_logs" {
  description = "The name of the S3 bucket used for logging access to bucket `bucket_name_for_central_logging`."
  default = "audit-account-eu-west-1-log-access-logs"
}

variable "lifecycle_glacier_transition_days" {
  description = "The number of days after object creation when the object is archived into Glacier."
  default     = 90
}

variable "key_deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days."
  default     = 10
}

variable "audit_account_id" {
  description = "The account ID of the `audit-account`account."
}

variable "region" {
  description = "The region used for the AWS provider."
}

variable "aws_account_list" {
  description = "The list of AWS accounts that want to send logs to `audit-account`."
  type = list(string)
}

variable "terraform_tags" {
  description = "The map of default tags which is used for tagging resources created by this script."
  type = map(string)
}
