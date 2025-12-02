#!/bin/bash

set -euo pipefail
# ./sysProbe.sh

cleanup(){
    echo "Cleaning up and Terminating the Program"
}



trap cleanup EXIT



check_dependencies() {
    local DEPENDENCIES=("curl" "uptime" "free" "df" "lscpu" "grep" "awk" "sed")
    local MISSING=()
    
    echo "Checking script dependencies..."

    for cmd in "${DEPENDENCIES[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            MISSING+=("$cmd")
        fi
    done

    if [ ${#MISSING[@]} -ne 0 ]; then
        echo "ERROR: The following required commands are missing:"
        echo "    ---> ${MISSING[*]}"
        echo "Please install them to run this script."
        exit 1
    fi
    echo "All dependencies found."
}

check_dependencies





DEVICE_NAME=$(hostname)

# kernel
kernel_name=$(uname -s)
kenel_release=$(uname -r)
kernel_version=$(uname -v)


# operating system info

os_info_success=0

osinfo() {
    if [ -f /etc/os-release ]; then
    set +u  
        . /etc/os-release
    set -u  
    os_name=${NAME:-"Unknown OS"}
    os_version=${VERSION_ID:-"Unknown Version"}
    os_info_success=1
    
    fi
}

os_info

public_ip_address=$(curl -s ifconfig.me || echo "N/A (Service Failed)")

uptime=$(uptime || echo "N/A (Command Failed)")
ram_details=$(free -h || echo "N/A (Command Failed)")

disk_info=$(df -h || echo "N/A (Command Failed)")

cpu_info=$(lscpu 2>/dev/null)


CPU_MODEL=$(echo "$cpu_info" | grep 'Model name' | awk -F': ' '{print $2}' | sed 's/^[ \t]*//' || echo "N/A")
CPU_CORES=$(echo "$cpu_info" | grep 'CPU(s):' | head -1 | awk '{print $2}' || echo "N/A")
CPU_ARCH=$(echo "$cpu_info" | grep 'Architecture' | awk '{print $2}' || echo "N/A")


NC='\033[0m'       # No Color

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'

B_CYAN='\033[1;36m' 


echo -e "$B_CYAN======================================$NC"
echo -e "$GREEN          sysProbe$NC"
echo -e "$B_CYAN======================================$NC"

echo -e "Device:\t$CYAN$DEVICE_NAME$NC"
echo -e "Public IP:\t$CYAN$public_ip_address$NC"
echo -e "Date:\t$CYAN$(date)$NC"

echo -e "\n$BLUE--------------------------------------$NC"
echo -e "$BLUE Kernel & OS Details$NC"
echo -e "$BLUE--------------------------------------$NC"

if [ $os_info_success -eq 1 ]; then
    echo -e "OS:\t$GREEN$os_name$NC $os_version"
fi
echo -e "Kernel:\t$GREEN$kernel_name$NC"
echo -e "Release:\t$GREEN$kenel_release$NC"
echo -e "Version:\t$GREEN$kernel_version$NC"
echo -e "Uptime:\t$GREEN$uptime$NC" 

echo -e "\n$BLUE--------------------------------------$NC"
echo -e "$BLUE CPU Details (Summary)$NC"
echo -e "$BLUE--------------------------------------$NC"



echo -e "Model:\t$CYAN$CPU_MODEL$NC"
echo -e "Cores:\t$CYAN$CPU_CORES$NC"
echo -e "Arch:\t$CYAN$CPU_ARCH$NC"

echo -e "\n$BLUE--------------------------------------$NC"
echo -e "$BLUE Memory & Disk$NC"
echo -e "$BLUE--------------------------------------$NC"


echo -e "RAM Usage:\n$YELLOW$ram_details$NC"


echo -e "\nDisk Information:\n$YELLOW$disk_info$NC"

echo -e "\n$B_CYAN======================================$NC"