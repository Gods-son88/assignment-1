#!/bin/bash
echo "--- System Information ---"
echo "Hostname: $(hostname)"
echo "Current User: $(whoami)"
echo "Date/Time: $(date)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo "Working Directory: $(pwd)"