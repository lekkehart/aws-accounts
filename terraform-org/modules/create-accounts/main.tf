# ------------------------------------------------------------
# Create AWS organization
# ------------------------------------------------------------
resource "aws_organizations_organization" "org" {
  feature_set = "ALL"
}

# ------------------------------------------------------------
# Create AWS accounts in organization
# ------------------------------------------------------------
# WARNING: Deleting these "aws_organizations_account" resources will only remove an AWS account from an organization.
# Terraform will not close the account. The member account must be prepared to be a standalone account
# beforehand. See the AWS Organizations documentation for more information.
# https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_remove.html
resource "aws_organizations_account" "test2_audit" {
  name  = "test2+audit"
  email = "test2+audit@ekkesoft.se"
}

resource "aws_organizations_account" "test2_group1_dev" {
  name  = "test2+group1+dev"
  email = "test2+group1+dev@ekkesoft.se"
}

resource "aws_organizations_account" "test2_group2_dev" {
  name  = "test2+group2+dev"
  email = "test2+group2+dev@ekkesoft.se"
}
