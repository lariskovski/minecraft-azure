# Minecraft Server IaC

Provision, configure and manage a Minecraft server on Azure.

Based on [this project](https://github.com/futurice/terraform-examples/blob/master/google_cloud/minecraft/main.tf)

## Executing The Project

### Requirements

- Ansible

- Terraform

- Create a Service Principal account

### Terraform Execution

Add the required values on vars.out.tfvars or pass them via env vars.

~~~~
terraform -chdir=terraform/ init
terraform -chdir=terraform/ plan -out plano
terraform -chdir=terraform/ apply plano
~~~~


## World Backup

~~~~
# create storage minebk account and container mine
# go to storage account > access key (accountkey)
tar -cf latest.tar latest/
az storage blob upload --file ~/mine-bkp/latest.tar/ --container mine --account-name minebkp --name latest --account-key xxxxx
~~~~