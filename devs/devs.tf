variable "name" {
  description = "Server and owner identifier"
  default = "dev-aws-creds"
}

variable "aws_region" {
  description = "Default AWS Region"
  default = "us-east-1"
}

# Configure remote workspace for .tfstate file
terraform {
  backend "remote" {
    organization = "rlwalk"

    workspaces {
      name = "devs"
    }
  }
}

# Declare ops workspace
data "terraform_remote_state" "ops" {
  backend = "remote"

  config = {
    organization = "rlwalk"

    workspaces = {
      name = "ops"
    }
  }
}

# Grab dynamic aws creds path and role from Ops output
data "vault_aws_access_credentials" "creds" {
  backend = data.terraform_remote_state.ops.outputs.backend
  role = data.terraform_remote_state.ops.outputs.role
}

# Declare aws provider using dynamic credentials
provider "aws" {
  access_key = "${data.vault_aws_access_credentials.creds.access_key}"
  secret_key = "${data.vault_aws_access_credentials.creds.secret_key}"
  region = "${var.aws_region}"
}

# Create AWS EC2 Instance
resource "aws_instance" "main" {
  ami           = "ami-0cfee17793b08a293"
  instance_type = "t2.micro"

  tags = {
    Name  = "${var.name}"
    owner = "${var.name}-webapp"
  }
}
