#!/bin/bash
domain=$1
virt-install \
    --name $domain \
    --memory 1024 \
    --noreboot \
    --os-variant detect=on,name=fedora-unknown \
    --cloud-init "user-data=${PWD}/cloudinit-user-data.yaml,ssh-key=${HOME}/.ssh/id_rsa.pub" \
    --disk=size=10,backing_store="${PWD}/Fedora-Cloud-Base-33-1.2.x86_64.qcow2"
    # -w network=default \
