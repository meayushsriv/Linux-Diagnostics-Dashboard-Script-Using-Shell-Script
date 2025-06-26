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

printf "\n"
printf "╔══════════════════════════════════════════════════════════════════════╗\n"
printf "║                      SYSTEM HEALTH SUMMARY                          ║\n"
printf "╠══════════════════════════════════════════════════════════════════════╣\n"
printf "║ HOSTNAME              : %-45s ║\n" "$HOSTNAME"
printf "║ OPERATING SYSTEM      : %-45s ║\n" "$SYSTEM"
printf "║ IP ADDRESS            : %-45s ║\n" "$IP"
printf "║ DISK USAGE (/)        : %-10s / %-31s ║\n" "$USED_DISK" "$AVAILABLE_DISK"
printf "║ SHARE USAGE (/wikijs) : %-10s / %-31s ║\n" "$SHARE_USE" "$SHARE_TOTAL"
printf "╠══════════════════════════════════════════════════════════════════════╣\n"
printf "║ CPU CORES             : %-45s ║\n" "$CPU_CORE"
printf "║ CPU USAGE             : %-45s ║\n" "$CPU_PERCENT"
printf "║ LOAD AVERAGE          : %-5s (1m) | %-5s (5m) | %-5s (15m)        ║\n" "$LOAD1" "$LOAD2" "$LOAD3"
printf "║ MEMORY USAGE          : %-10s / %-31s ║\n" "$MEMORY_USE" "$MEMORY_TOTAL"
printf "║ SWAP USAGE            : %-4s MB / %-31s MB         ║\n" "$SWAP_USE" "$SWAP_TOTAL"
printf "╠══════════════════════════════════════════════════════════════════════╣\n"
printf "║ SSH SERVICE           : %-45s ║\n" "$SSH_STATUS"
printf "║ SAMBA SERVICE         : %-45s ║\n" "$SAMBA_STATUS"
printf "║ NTP SERVICE           : %-45s ║\n" "$NTP_STATUS"
printf "║ NTP SYNCHRONIZED      : %-45s ║\n" "$NTP_SYNC"
printf "║ SNMP SERVICE          : %-45s ║\n" "$SNMP_STATUS"
printf "║ FTP SERVICE           : %-45s ║\n" "$FTP_STATUS"
printf "╚══════════════════════════════════════════════════════════════════════╝\n"