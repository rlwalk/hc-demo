/* This file is not meant to be executed within a shell
in it's entirety. The commands below are used to setup
environment variables for Terraform to consume in
cunjuction with an AWS provider.
*/


export TF_VAR_aws_access_key=<AWS_ACCESS_KEY>
export TF_VAR_aws_secret_key=<AWS_SECRET_KEY>
export TF_CLI_ARGS_apply="-auto-approve"
