variable "region" {
  default = "eu-west-1"
}

locals {
  terraform_tags = {
    created_by          = "terraform"
    project             = "aws-accounts"
    terraform_workspace = terraform.workspace
  }
}
