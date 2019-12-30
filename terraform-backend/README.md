# `terraform-backend`

_NOTE: 
This is a one-time setup, i.e. it has been run only once. 
It is included here purely for documentation purposes._

* Sets up the backend for storing Terraform state remotely in an S3 bucket protected by a lock in a DynamoDB table.
* Requires some basic pre-requisites before it can be run. 

## Pre-requisites

* Create a user:
  * user name: `terraform-admin`.
  * with programmatic access providing you with `aws_access_key_id` and `aws_secret_access_key` 
  * with AdministratorAccess rights.
  
* Run `aws configure` with the settings for above user:

```
  aws configure
  AWS Access Key ID [...]:
  AWS Secret Access Key [...]:
  Default region name [...]:
  Default output format [json]:
```

## Run

Run the terraform script which creates the terraform backend resources:

```
  cd terraform-backend
  terraform init
  terraform plan
  terraform apply
```
