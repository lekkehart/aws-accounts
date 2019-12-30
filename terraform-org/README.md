# `terraform-org`

_NOTE: Is to be run every time a new AWS account has to be created._

* `modules\create-accounts:` Creates AWS accounts.
* `modules\provision-audit-account:` Provisions AWS account `audit-account` with its specific resources required. 

## Workflow

Let's create the following user in order to illustrate what the workflow is:
* AWS account name: `test2+xxx+yyy`
* Email: `test2+xxx+yyy@ekkesoft.se`

### Steps

1.  Create `aws_organizations_account` in file `modules/create-accounts/main.tf`:

    ```
    resource "aws_organizations_account" "xxx_yyy" {
      name      = "test2+xxx+yyy"
      email     = "test2+xxx+yyy@ekkesoft.se"
    }
    ```

1.  Plan & apply terraform.

    ```
    terraform init
    terraform plan
    terraform apply
    ```

1.  This outputs account details, e.g. the account numbers as required later
    by [aws-accounts-baseline](https://github.com/lekkehart/aws-accounts-baseline):

    ```
    aws_accounts = [
      {
        "arn" = ...
        "email" = ...
        "id" = 123456789012
        "name" = test2+xxx+yyy
      },
      ...
    ]
    ```

1.  It also outputs the CloudTrail S3 bucket name as well as the KMS key which is to be used for encrypting the
    CloudTrails. Even these are later required by the
    [aws-accounts-baseline](https://github.com/lekkehart/aws-accounts-baseline):

    ```
    audit_cloudtrail_kms_key_arn = ...
    cloudtrail_s3_bucket_name = ...
    ```
   
        
## What does it do underneath?

* Creates AWS accounts.
* Provisions the `audit-account`account with information about the newly created account.
  It modifies S3 bucket policy and KMS policy in the `audit-account` account such that the new account is allowed to send logging information to `audit-account`. 
