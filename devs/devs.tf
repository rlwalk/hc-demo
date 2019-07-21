# Set server owner identifier
variable "identifier" {
  description = "Server and owner identifier"
  default = "dev-aws-team"
}

# Set Default AWS Region
variable "aws_region" {
  description = "Default AWS Region"
  default = "us-east-1"
}

# Set path to ops state file
variable "path" {
  default = "../ops/terraform.tfstate"
}

# Set state file to be stored locally
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

data "terraform_remote_state" "ops" {
  backend = "local"

  config = {
    path = "${var.path}"
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
    Name  = "${var.identifier}"
    owner = "${var.identifier}-webapp"
  }
}
