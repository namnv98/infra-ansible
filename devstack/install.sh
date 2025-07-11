#!/bin/bash
#ansible-playbook -i inventory.ini install-devstack.yml
ansible-playbook -i inventory.ini change_ip.yml

#ansible-playbook -i inventory.ini remove-devstack.yml -e "remove_packages=true"



#export TERM=xterm

#source /opt/stack/devstack/openrc admin
#openstack server show vm-01 -f yaml | grep -i addresses