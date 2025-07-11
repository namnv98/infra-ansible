#ansible-playbook -i inventory.ini remove-devstack.yml -e "remove_packages=true"
ansible-playbook -i inventory.ini devstack.yml

#export TERM=xterm

#source /opt/stack/devstack/openrc admin
#openstack server show vm-01 -f yaml | grep -i addresses

#
#openstack server create
#  --flavor m1.nano
#  --image cirros-0.6.3-x86_64-disk
#  --network private
#  --security-group 99fe1cbb-e4e1-4c14-8a39-542af2b7fd98
#  vm-01
#
#
#openstack server delete vm-01
#





