/* This file is not meant to be executed within a shell
in it's entirety. The intention is to provide a series
of commands to enable HashiCorp Vault server in dev mode
as well as enable dynamic secrets engine for AWS.
*/

## Start vault server with dev data
vault server -dev -dev-root-token-id=root

##Add vault address as environment variable
$ export VAULT_ADDR='http://127.0.0.1:8200’
$ export VAULT_TOKEN=root

##Grab unseal key:

Dynamic Secrets w/AWS

## Enable AWS engine
vault secrets enable -path=aws-dyn-cred aws

## List Secrets Engines
vault secrets list

##Configure AWS Account
vault write aws-dyn-cred/config/root \
access_key=<AWS_ACCESS_KEY> \
secret_key=<AWS_SECRET_KEY> \
    region=us-east-1

## Shorten lease
vault write aws-dyn-cred/config/lease \
        lease=120s \
        lease_max=240s

## Create IAM-Role
vault write aws-dyn-cred/roles/my-role \
        credential_type=iam_user \
        policy_document=-<<EOF
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

##Generate a secret
vault read aws-dyn-cred/creds/my-role

##Revoke the secret
vault lease revoke <lease_id>

##Delete AWS role
vault delete aws-dyn-cred/roles/my-role
