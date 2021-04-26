# Minecraft Server IaC

Provision, configure and manage a Minecraft server on Azure.

Based on [this project](https://github.com/futurice/terraform-examples/blob/master/google_cloud/minecraft/main.tf)

## Executing The Project

### Requirements

- Ansible

- Terraform

- A Service Principal account and the following values:
        subscription_id, 
        client_id, 
        client_secret, 
        tenant_id

- Create SSH key. Default vars look to ``~/.ssh/azure-mine.pub`` and ``~/.ssh/azure-mine``

### Terraform Execution

Add the required values on vars.out.tfvars or pass them via env vars.

> Note: Terraform makes use of the local-exec provisioner to call the Ansible Playbook.

Once the vars are set and the SSH keys in place, execute the follwing:

~~~~
terraform -chdir=terraform/ init
terraform -chdir=terraform/ plan -out plano
terraform -chdir=terraform/ apply plano
~~~~

## Connecting to the Server

Copy the public_ip output and add as the minecraft server on the client application.

Alternatively, if you only want to check it's working check [Minecraft Server Stat](https://mcsrvstat.us/).

## World Backup

If you have a world backup locally you can send it directly to the server as port 22 is open or sending it to an storage account then downloading it from the server. The second aproach is also good if you want to setup a cron job for future backups, which is recommended.

### Storage Account Creationg and World Upload

Example SA setup:

- Create storage account called ``minebkp`` and container called ``mine`` (or any other creative names you'd like)

- Go to Storage Account > Access Key (accountkey)

~~~~
SA=minebkp
CONTAINER=mine
AKEY=XXXXXX
# compress your world file
tar -cf world.tar world/
az storage blob upload --file ./world.tar/ --container $CONTAINER --account-name $SA --name latest --account-key $AKEY
~~~~

## Good Reads

[Integrating Terraform and Ansible](https://github.com/ernesen/Terraform-Ansible)