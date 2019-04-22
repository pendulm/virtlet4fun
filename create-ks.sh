#!/bin/bash

virt-install  \
  --name fedora-ks \
  --memory 2048             \
  --vcpus=2                 \
  --cpu host                \
  --location http://mirrors.163.com/fedora/releases/29/Server/x86_64/os/ \
  --disk size=20,format=qcow2  \
  --virt-type kvm \
  --network user            \
  --nographics \
  --qemu-commandline="-nic user,hostfwd=tcp::2222-:22" \
  --initrd-inject=anaconda-ks.cfg --extra-args "ks=file:/anaconda-ks.cfg console=ttyS0"
