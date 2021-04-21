# Project Part 03: Ansible Configurations

## Test connection to the created server

~~~~
ssh-agent bash
ssh-add ~/.ssh/azure-mine
ansible -i hosts all -m ping -b
~~~~

## Continue playbook from error

~~~~
ansible-playbook -i hosts main.yml --start-at-task="Install basic setup packages"
~~~~

## Minecraft Server Properties

https://minecraft.fandom.com/wiki/Server.properties