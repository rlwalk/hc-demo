# Presentation of HashiCorp Cloud Operating Model for MI SE role




## Resources
- [AWS](https://aws.amazon.com)
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
