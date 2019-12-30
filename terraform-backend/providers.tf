provider "aws" {
  region  = var.region
  version = "~> 2.43"
}

terraform {
  required_version = ">= 0.12"
}
