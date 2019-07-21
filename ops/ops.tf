variable "aws_access_key" {
  description = "Access Key to AWS user who can create IAM users"
}
variable "aws_secret_key" {
  description = "Secret Key for AWS user"
 }
variable "dev-creds"           {
  description = "The name for the Vault path for the developer creds"
  default = "dev-aws-creds"

}

# Tell Terraform to use local backend
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "vault" {}

resource "vault_aws_secret_backend" "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  path       = "${var.dev-creds}-path"
  region = "us-east-1"
  default_lease_ttl_seconds = "120"
  max_lease_ttl_seconds     = "240"
}

resource "vault_aws_secret_backend_role" "ops" {
  backend = "${vault_aws_secret_backend.aws.path}"
  name    = "${var.dev-creds}-role"
  credential_type = "iam_user"

  policy_document = <<EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "ec2:*",
                  "iam:*"
              ],
              "Resource": "*"
          }
      ]
  }
  EOF
}

output "backend" {
  value = "${vault_aws_secret_backend.aws.path}"
}

output "role" {
  value = "${vault_aws_secret_backend_role.ops.name}"
}
