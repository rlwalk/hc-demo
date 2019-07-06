variable "aws_access_key" { }
variable "aws_secret_key" { }
variable "name"           { default = "dev-aws-creds" }

/*
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
*/

terraform {
  backend "remote" {
    organization = "rlwalk"

    workspaces {
      name = "ops"
    }
  }
}

provider "vault" {}

resource "vault_aws_secret_backend" "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  path       = "${var.name}-path"
  region = "us-east-1"
  default_lease_ttl_seconds = "120"
  max_lease_ttl_seconds     = "240"
}

resource "vault_aws_secret_backend_role" "ops" {
  backend = "${vault_aws_secret_backend.aws.path}"
  name    = "${var.name}-role"
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
