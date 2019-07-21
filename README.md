# Presentation of HashiCorp Cloud Operating Model for MI SE role




## Resources
- [AWS](https://console.aws.amazon.com/console/home?region=us-east-1#)
- [Terraform Cloud](https://app.terraform.io/app/rlwalk/workspaces)
- [HashiCorp GitHub Dynamic AWS Credentials](https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/dynamic-aws-creds)
- [HashiCorp's Vault](https://www.vaultproject.io/)
- [Terraform Vault provider](https://www.terraform.io/docs/providers/vault/)
- [Vault AWS Secret Engine](https://www.vaultproject.io/docs/secrets/aws/index.html)


## Environment Setup

Vault Setup

Download and install Vault

```sh

$ vault server -dev -dev-root-token-id=root

export VAULT_TOKEN=root
export VAULT_ADDR=http://127.0.0.1:8200

```


Terraform Setup

Ensure user token exists
```sh
$ vi ~/.terraformrc
```
```sh
credentials "app.terraform.io" {
     token = "QkeAI5u7y0HuGA.atlasv1.ocGMXKzmtUEnITreDK2ur9MRHtje8WLeP9NPdj0kgyBODneFAxsyBjid55sVt4O0JP0"
   }
```

Add TF vars for AWS Keys
```sh
export TF_VAR_aws_access_key=${AWS_ACCESS_KEY_ID} # AWS Access Key ID - This command assumes the AWS Access Key ID is set in your environment as AWS_ACCESS_KEY_ID
export TF_VAR_aws_secret_key=${AWS_SECRET_ACCESS_KEY} # AWS Secret Access Key - This command assumes the AWS Access Key ID is set in your environment as AWS_SECRET_ACCESS_KEY
```
