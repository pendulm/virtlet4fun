#!/bin/bash

domain=$1
virsh destroy $domain
virsh undefine $domain --remove-all-storage
