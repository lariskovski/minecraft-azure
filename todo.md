### Terraform

- [x] Open port 25565

- [x] Create persistent data disk

- [x] Create VM

- [x] Create Azure function

- [x] Terraform create Ansible Hosts file

- [ ] Create App Registration (service account) on Active Directory

- [ ] [Create iam permission for the App Registration. Function App > IAM > Role Assignments](https://stackoverflow.com/questions/42134892/the-client-with-object-id-does-not-have-authorization-to-perform-action-microso)

- [ ] Set VM to spot

- [ ] Refactor to ddd env variables for Resource Group name, VM name etc

### Ansible

- [ ] Publish function code to Function App

- [ ] Format disk if necessary

- [ ] Mount disck sdc1

- [ ] Install Docker

- [ ] [Run container](https://github.com/lariskovski/terraform-examples/blob/master/google_cloud/minecraft/main.tf#L94)

- [ ] Check container

[Integrating Terraform and Ansible](https://github.com/ernesen/Terraform-Ansible)

###  Function

- [ ] Check current status before start/stop

- [ ] operation=status, returns vm status

- [ ] Add variables for Resource Group and VM name

- [ ] [Auth](https://stackoverflow.com/questions/42134892/the-client-with-object-id-does-not-have-authorization-to-perform-action-microso)