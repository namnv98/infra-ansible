#!/bin/bash

ansible-playbook playbooks/install.yml


#openssl req -x509 -nodes -days 365 \
#  -newkey rsa:2048 \
#  -keyout tls.key \
#  -out tls.crt \
#  -subj "/CN=namnv.tech.com/O=namnv"