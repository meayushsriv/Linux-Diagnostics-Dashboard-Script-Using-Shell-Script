#!/bin/bash

HOSTNAME=$(uname -n)
SLASH=" / "

MEMORY_TOTAL=$(free -m | awk 'NR==2 {print $2 " MB"}')
MEMORY_USE=$(free -m | awk 'NR==2 {print $3 " MB"}')
SWAP_USE=$(free -m | awk '/^Swap/ {print $3}')
SWAP_TOTAL=$(free -m | awk '/^Swap/ {print $2}')

USED_DISK=$(df -h / | awk 'NR==2 {print $3}')
AVAILABLE_DISK=$(df -h / | awk 'NR==2 {print $2}')

if [ -d "/wikijs" ]; then
    SHARE_USE=$(df -Ph /wikijs | grep /dev | awk '{print $3}')$SLASH
    SHARE_TOTAL=$(df -Ph /wikijs | grep /dev | awk '{print $2}')
else
    SHARE_USE="/share not found"
    SHARE_TOTAL=""
fi

SYSTEM=$(grep -w "NAME" /etc/os-release | cut -d= -f2 | tr -d '"')
IP=$(ip a show wlan0 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1)
if [ -z "$IP" ]; then
    IP=$(ip a show eth0 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1)
fi

CPU_PERCENT=$(mpstat 1 1 | awk '/Average:/ && $NF ~ /[0-9.]+/ {printf "%.2f%%", 100 - $NF}')
CPU_CORE=$(nproc)

SSH_STATUS=$(systemctl is-active ssh)
SNMP_STATUS=$(systemctl is-active snmpd)
FTP_STATUS=$(systemctl is-active vsftpd)
SAMBA_STATUS=$(systemctl is-active smbd)
NTP_STATUS=$(systemctl is-active systemd-timesyncd)
NTP_SYNC=$(timedatectl | grep 'NTP synchronized:' | awk '{print $3}')
