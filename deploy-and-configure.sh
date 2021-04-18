#!/bin/bash
terraform -chdir=terraform/ apply -auto-approve

export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook --private-key ~/.ssh/azure-mine \
        --user azureuser                         \
        --inventory ansible/hosts                \
        ansible/main.yml
        # --start-at-task="Copy manage module file" \