#!/bin/bash

set -euo pipefail
# ./sysProbe.sh

cleanup(){
    echo "Cleaning up and Terminating the Program"
}

VERSION="0.0.1"


trap cleanup EXIT


# Device details

DEVICE_NAME=$(hostname)

# kernel
kernel_name=$(uname -s)
kenel_release=$(uname -r)
kernel_version=$(uname -v)








































# echo "$VERSION"




# Hostname      
# OS            
# Kernel       
# uptime_info
# cpu_model   cpu_usage
# disk_root
# ram_used
# ip address 
