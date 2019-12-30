variable "region" {
  default = "eu-west-1"
}

locals {
  terraform_tags = {
    created_by          = "terraform"
    terraform_workspace = terraform.workspace
  }

  tfstate_bucket_name = "ekklot-org-${var.region}-terraform-state"
}
