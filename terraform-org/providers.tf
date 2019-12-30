provider "aws" {
  region  = var.region
  version = "~> 2.43"
}

terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket  = "ekklot-org-eu-west-1-terraform-state"
    key     = "aws-accounts.tfstate"
    region  = "eu-west-1"
    encrypt = "true"
    dynamodb_table = "ekklot-org-eu-west-1-terraform-state-lock"
  }
}
