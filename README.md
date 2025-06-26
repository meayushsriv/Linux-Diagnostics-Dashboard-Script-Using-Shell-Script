# System Health Monitor

A comprehensive bash script that displays real-time system information in a formatted table view.

## Overview

This script provides a quick overview of your Linux system's health status, including hardware resources, network information, and service status. It presents the information in an easy-to-read ASCII table format.

## Features

### System Information

- **Hostname**: Current system hostname
- **Operating System**: Detected from `/etc/os-release`
- **IP Address**: Automatically detects IP from wireless (wlan0) or ethernet (eth0) interfaces

### Resource Monitoring

- **Disk Usage**: Shows used vs. available space for root filesystem (/)
- **Share Usage**: Monitors `/wikijs` directory if present
- **CPU Information**: Number of cores and current usage percentage
- **Memory Usage**: RAM usage (used/total in MB)
- **Swap Usage**: Swap space utilization

### Service Status Monitoring

- SSH Service (ssh)
- Samba Service (smbd)
- NTP Service (systemd-timesyncd)
- NTP Synchronization Status
- SNMP Service (snmpd)
- FTP Service (vsftpd)

## Prerequisites

The script requires the following commands to be available:

- `free` - for memory information
- `df` - for disk usage
- `ip` - for network interface information
- `mpstat` (from sysstat package) - for CPU usage
- `nproc` - for CPU core count
- `systemctl` - for service status
- `timedatectl` - for NTP sync status
- `awk`, `grep`, `cut`, `tr` - text processing utilities

### Installing Dependencies

On Ubuntu/Debian systems:

```bash
sudo apt update
sudo apt install sysstat
```

On RHEL/CentOS/Fedora systems:

```bash
sudo yum install sysstat
# or
sudo dnf install sysstat
```

## Usage

1. Make the script executable:

   ```bash
   chmod +x system_health.sh
   ```

2. Run the script:
   ```bash
   ./system_health.sh
   ```

## Sample Output

```
╔══════════════════════════════════════════════════════════════════════╗
║                      SYSTEM HEALTH SUMMARY                           ║
╠══════════════════════════════════════════════════════════════════════╣
║ HOSTNAME              : myserver                                     ║
║ OPERATING SYSTEM      : Ubuntu 22.04.3 LTS                           ║
║ IP ADDRESS            : 192.168.1.100                                ║
║ DISK USAGE (/)        : 25G       / 50G                              ║
║ SHARE USAGE (/wikijs) : 5.2G      / 100G                             ║
╠══════════════════════════════════════════════════════════════════════╣
║ CPU CORES             : 4                                            ║
║ CPU USAGE             : 15.25%                                       ║
║ LOAD AVERAGE          :       (1m) |       (5m) |       (15m)        ║
║ MEMORY USAGE          : 2048 MB    / 8192 MB                         ║
║ SWAP USAGE            : 0 MB / 2048 MB                               ║
╠══════════════════════════════════════════════════════════════════════╣
║ SSH SERVICE           : active                                       ║
║ SAMBA SERVICE         : active                                       ║
║ NTP SERVICE           : active                                       ║
║ NTP SYNCHRONIZED      : yes                                          ║
║ SNMP SERVICE          : inactive                                     ║
║ FTP SERVICE           : active                                       ║
╚══════════════════════════════════════════════════════════════════════╝
```

## Known Issues

1. **Load Average Display**: The script defines variables `$LOAD1`, `$LOAD2`, and `$LOAD3` for load averages but doesn't populate them. You may want to add:

   ```bash
   LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | sed 's/,//g')
   LOAD1=$(echo $LOAD_AVG | awk '{print $1}')
   LOAD2=$(echo $LOAD_AVG | awk '{print $2}')
   LOAD3=$(echo $LOAD_AVG | awk '{print $3}')
   ```

2. **Network Interface Detection**: The script checks for `wlan0` first, then `eth0`. Modern systems may use different interface naming conventions (e.g., `enp0s3`, `wlp2s0`).

## Customization

- **Adding Services**: To monitor additional services, add new variables following the pattern:

  ```bash
  SERVICE_STATUS=$(systemctl is-active service-name)
  ```

- **Changing Monitored Directory**: Replace `/wikijs` with your desired directory path in the share usage section.

- **Network Interfaces**: Modify the IP detection section to match your system's interface names.

## Automation

To run this script automatically at login, add it to your shell profile:

```bash
echo "./path/to/system_health.sh" >> ~/.bashrc
```

Or set it up as a cron job for periodic monitoring:

```bash
# Run every hour
0 * * * * /path/to/system_health.sh >> /var/log/system_health.log
```
