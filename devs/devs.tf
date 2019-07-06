variable "name" { default = "dynamic-aws-creds-consumer" }
variable "path" { default = "../ops/terraform.tfstate" }
variable "ttl"  { default = "1" }

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
      name = "devs"
    }
  }
}


data "terraform_remote_state" "producer" {
  backend = "local"

  config = {
    path = "${var.path}"
  }
}

data "vault_aws_access_credentials" "creds" {
#  backend = "${data.terraform_remote_state.producer.backend}"
#  role = "${data.terraform_remote_state.producer.role}"
  backend = "dynamic-aws-creds-producer-path"
  role = "dynamic-aws-creds-producer-role"
}

provider "aws" {
  access_key = "${data.vault_aws_access_credentials.creds.access_key}"
  secret_key = "${data.vault_aws_access_credentials.creds.secret_key}"
  region = "us-east-1"
}

# Create AWS EC2 Instance
resource "aws_instance" "main" {
  ami           = "ami-0cfee17793b08a293"
  instance_type = "t2.micro"

  tags = {
    Name  = "${var.name}"
    TTL   = "${var.ttl}"
    owner = "${var.name}-guide"
  }
}
