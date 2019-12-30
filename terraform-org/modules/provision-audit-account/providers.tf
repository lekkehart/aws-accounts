provider "aws" {
  region  = var.region
  version = "~> 2.43"

  assume_role {
    role_arn = "arn:aws:iam::${var.audit_account_id}:role/OrganizationAccountAccessRole"
    session_name = "SESSION_NAME"
    external_id = "EXTERNAL_ID"
  }
}
