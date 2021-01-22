#!/bin/bash
# export LIBVIRT_DEFAULT_URI=qemu:///system
del_dns() {
    local domain=$1
    local mac=$(virsh dumpxml $domain|awk -F"'" '/mac address/{print $2}')
    [[ -z $mac ]] && return
    local ip=$(virsh --connect qemu:///system net-dhcp-leases default|grep ${mac}|awk '{print $5}'|awk -F/ '{print $1}')
    virsh --connect qemu:///system  net-update default delete  dns-host \
        "<host ip='${ip}'>
            <hostname>${domain}</hostname>
            </host>" \
                --live --config
}

domain=${1:-fedora33}
del_dns $domain
virsh destroy $domain
sleep 2
virsh undefine $domain --remove-all-storage
