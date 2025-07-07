#!/bin/bash

ansible-playbook playbooks/install.yml


#openssl req -x509 -nodes -days 365 \
#  -newkey rsa:2048 \
#  -keyout tls.key \
#  -out tls.crt \
#  -subj "/CN=namnv.tech.com/O=namnv"



kubectl run curl-test -n longhorn-system \
  --image=curlimages/curl \
  --restart=Never \
  --command -- sleep 3600
#
#curl -vk https://longhorn-conversion-webhook.longhorn-system.svc:9501/v1/healthz



