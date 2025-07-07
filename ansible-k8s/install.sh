#!/bin/bash
#ansible-playbook playbooks/reset.yml
#ansible-playbook playbooks/uninstall.yml
ansible-playbook playbooks/main.yml




#gcloud compute firewall-rules create allow-custom-ports \
#  --project="master-scope-462801-r2" \
#  --network="default" \
#  --priority=1000 \
#  --direction=INGRESS \
#  --action=ALLOW \
#  --rules="tcp:179,tcp:5432,tcp:6443,tcp:9501,udp:1194" \
#  --source-ranges="0.0.0.0/0" \
#  --target-tags="a" \
#  --enable-logging=no



#gcloud compute instances create "k8s-02" \
#  --project="master-scope-462801-r2" \
#  --zone="asia-southeast1-a" \
#  --machine-type="c2-standard-4" \
#  --image-family="debian-12" \
#  --image-project="debian-cloud" \
#  --boot-disk-size="10GB" \
#  --boot-disk-type="pd-balanced" \
#  --boot-disk-device-name="k8s-node-01" \
#  --metadata=enable-oslogin=false,enable-osconfig=TRUE,ssh-keys="namnv:ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBKT+X+GVJ1EwWxT+nHb6CdCkChG5be/W9ZEHGbq5dQiKsDKBWiNdZlCocKMmxX6MmTeiB/eZ0GxiHI6qRuK9/6A=" \
#  --tags="a" \
#  --scopes=cloud-platform





