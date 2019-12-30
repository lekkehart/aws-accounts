output "aws_accounts" {
  description = "The map of AWS account names/numbers."
  value       = aws_organizations_organization.org.accounts[*]
}

output "aws_audit_account" {
  value = aws_organizations_account.test2_audit.id
}
