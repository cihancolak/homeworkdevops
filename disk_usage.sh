#!/bin/bash

# Activate colour changes.
trap 'tput cnorm' EXIT
tput setaf 7  # White text colour

# Control disk usage
disk_usage=$(df -h /home | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $disk_usage -gt 80 ]; then
  tput setaf 1  # Red text colour
  echo "Warning: Disk usage is critical! ($disk_usage%)" >&2
  tput setaf 7  # Back white colour
fi

# Backup Logs
log_dir="/var/log"
backup_dir="./backup/logs"
if [ ! -d "$backup_dir" ]; then
  mkdir -p "$backup_dir"
fi
cp "$log_dir"/*.log "$backup_dir"
echo "Logs '$backup_dir' backup saved."

# if report folder not created and then create new folder
system_health_dir=."/home/admin"
if [ ! -d "$system_health_dir" ]; then
  mkdir -p "$system_health_dir"
fi

# Create system health report file name.
report_file="home/admin/system_health_$(date +%F).txt"

# touch and put system health report to report_file
touch "$report_file"

{
  echo "System Health Report"
  echo "------------------"
  echo "Date and Time: $(date)"
  echo "System uptime: $(uptime)"
  echo "Memory Usage:"
  free -m
} > "$report_file"
echo "System Health Report '$report_file' created."

tput setaf 2  # Green colour
echo "All proccess Completed"
tput setaf 7  # Back to the white.
