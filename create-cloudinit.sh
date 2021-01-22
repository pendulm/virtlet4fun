#!/bin/bash
# export LIBVIRT_DEFAULT_URI=qemu:///system

add_dns() {
    local domain=$1
    local mac=$(virsh dumpxml $domain|awk -F"'" '/mac address/{print $2}')
    [[ -z $mac ]] && return
    local ip=$(virsh --connect qemu:///system net-dhcp-leases default|grep ${mac}|awk '{print $5}'|awk -F/ '{print $1}')
    virsh --connect qemu:///system  net-update default add  dns-host \
        "<host ip='${ip}'>
            <hostname>${domain}</hostname>
            </host>" \
                --live --config
}

domain=${1:-fedora33}
tmp_cloud_conf=/tmp/tmp-${domain}.yaml
sed "/fqdn/s/fedora33/${domain}/" cloudinit-user-data.yaml > $tmp_cloud_conf
virt-install \
    --name $domain \
    --memory 1024 \
    --noreboot \
    --os-variant detect=on,name=fedora-unknown \
    --cloud-init "user-data=${tmp_cloud_conf},ssh-key=${HOME}/.ssh/id_rsa.pub" \
    --disk=size=5,backing_store="${PWD}/Fedora-Cloud-Base-33-1.2.x86_64.qcow2" \
    --disk=size=6 \
    --network bridge=virbr0
add_dns $domain
rm -f $tmp_cloud_conf
