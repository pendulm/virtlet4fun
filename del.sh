#!/bin/bash

virsh destroy fedora-ks
virsh undefine fedora-ks --remove-all-storage
