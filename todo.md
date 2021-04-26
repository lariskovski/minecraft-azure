### Terraform

- [x] Open port 25565

- [x] Create persistent data disk

- [x] Create VM

- [x] Create Azure function

- [x] Terraform create Ansible Hosts file

- [x] Fix Service plan for function and deploy service app instead of function app

- [ ] Divide main code into modules

- [x] Add remote backend

- [ ] Set VM to spot

- [x] Refactor to ddd env variables for Resource Group name, VM name etc

- [ ] Update DNS entry with new IP

- [ ] Add env vars to function settings

- [ ] Output function URL

- [x] Add local-exec provisioner to call Ansible

### Ansible

- [x] Format disk if necessary

- [x] Mount disck sdc1

- [x] Download and install Minecraft

- [x] Check service

- [ ] Az Login

- [ ] Publish function code to Function App

- [ ] Download latest world files (if exists on storage account) & restart service

###  Function

- [ ] Add function usage on README

- [ ] Check current status before start/stop

- [ ] operation=status, returns vm status

- [ ] Add variables for Resource Group and VM name

- [ ] [Auth](https://stackoverflow.com/questions/42134892/the-client-with-object-id-does-not-have-authorization-to-perform-action-microso)

## Misc

- [ ] Add variables integration between ansible terraform etc