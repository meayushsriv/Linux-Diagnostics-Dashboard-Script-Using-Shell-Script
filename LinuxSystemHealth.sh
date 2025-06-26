#!/bin/bash

HOSTNAME=$(uname -n)
SLASH=" / "

MEMORY_TOTAL=$(free -m | awk 'NR==2 {print $2 " MB"}')
MEMORY_USE=$(free -m | awk 'NR==2 {print $3 " MB"}')
SWAP_USE=$(free -m | awk '/^Swap/ {print $3}')
SWAP_TOTAL=$(free -m | awk '/^Swap/ {print $2}')
