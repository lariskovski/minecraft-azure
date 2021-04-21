### Terraform

- [x] Open port 25565

- [x] Create persistent data disk

- [x] Create VM

- [x] Create Azure function

- [x] Terraform create Ansible Hosts file

- [x] Fix Service plan for function and deploy service app instead of function app

- [ ] Add env vars to function settings

- [ ] Fix function stop operation

- [ ] Add application insights for function

- [ ] Divide main code into modules

- [ ] Add remote backend

- [ ] [Create iam permission for the App Registration. Function App > IAM > Role Assignments](https://stackoverflow.com/questions/42134892/the-client-with-object-id-does-not-have-authorization-to-perform-action-microso)

- [ ] Set VM to spot

- [x] Refactor to ddd env variables for Resource Group name, VM name etc

- [ ] Update DNS entry with new IP

- [ ] Output function URL

- [ ] Add local exec to call Ansible

### Ansible

- [x] Format disk if necessary

- [x] Mount disck sdc1

- [x] Download and install Minecraft

- [x] Check service

- [ ] Az Login

- [ ] Publish function code to Function App

- [ ] Download latest world files (if exists on storage account) & restart service

[Integrating Terraform and Ansible](https://github.com/ernesen/Terraform-Ansible)

###  Function

- [ ] Check current status before start/stop

- [ ] operation=status, returns vm status

- [ ] Add variables for Resource Group and VM name

- [ ] [Auth](https://stackoverflow.com/questions/42134892/the-client-with-object-id-does-not-have-authorization-to-perform-action-microso)

## Misc

- [ ] Add variables integration between ansible terraform etc