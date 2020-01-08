# ------------------------------------------------------------
# Create AWS accounts
# ------------------------------------------------------------
module "create-accounts" {
  source = "./modules/create-accounts"
}

# ------------------------------------------------------------
# Provision audit-account account
# ------------------------------------------------------------
module "provision-audit-account" {
  source = "./modules/provision-audit-account"

  // TODO
  // Enforce module dependency, so that provision-audit-account is first run after create-accounts.
  // Not sure why it does not implicitly resolve this.

  region           = var.region
  audit_account_id = module.create-accounts.aws_audit_account
  aws_account_list = module.create-accounts.aws_accounts[*].id
  terraform_tags   = local.terraform_tags
}
