# Minecraft Server IaC

Provision, configure and manage a Minecraft server on Azure.

Based on [this project](https://github.com/futurice/terraform-examples/blob/master/google_cloud/minecraft/main.tf)

## World Backup

~~~~
# create storage minebk account and container mine
# go to storage account > access key (accountkey)
tar -cf latest.tar latest/
az storage blob upload --file ~/mine-bkp/latest.tar/ --container mine --account-name minebkp --name latest --account-key xxxxx
~~~~