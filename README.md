# aws-accounts

Purpose of this experimental project is to test creation of AWS accounts under an AWS organization.

The general workflow is that this project creates the accounts followed by provisioning the accounts with
a baseline set of features by means of [aws-accounts-baseline](https://github.com/lekkehart/aws-accounts-baseline).

The project demonstrates:
* [terraform-backend](terraform-backend) sets up the Terraform backend in S3 & DynamoDB.
  This is just for documentation purposes and was executed only once as a preparation for the real
  Terraform project [terraform-org](terraform-org).
* Terraform state files are stored centrally in the organization master account, i.e. even for all the child accounts of the
  AWS organization. 
* [terraform-org](terraform-org/main.tf) contains the code which is to be run whenever a new 
  AWS account is to be created.
  * [modules/create-accounts](terraform-org/modules/create-accounts/main.tf) creates the new AWS account. 
  * [modules/provision-audit-account](terraform-org/modules/provision-audit-account/main.tf) provisions the `audit` 
    account so that it accepts CloudTrail logs from the newly created AWS account.
    
_NOTE! There are better ways for creating CloudTrails in an organization now, see 
[Organization Trails](https://aws.amazon.com/about-aws/whats-new/2018/11/aws-cloudtrail-adds-support-for-aws-organizations/).
Nevertheless, it is useful to show this mechanism of provisioning the audit account for a new AWS account because
there could be other aspects that need to get set up centrally whenever there is a new account created._
