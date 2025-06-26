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