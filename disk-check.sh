#!/usr/bin/env bash
THRESHOLD=$1
TARGET_PATH=${2:-/}

if ! [[ "$THRESHOLD" =~ ^[0-9]+$ ]] || [ "$THRESHOLD" -lt 1 ] || [ "$THRESHOLD" -gt 100 ]; then
    echo "Error: Threshold must be an integer between 1 and 100." >&2
    exit 2
fi

USAGE=$(df "$TARGET_PATH" | awk 'NR==2 {print $5}' | tr -d '%')
echo "Disk usage for $TARGET_PATH: ${USAGE}%"

mkdir -p logs
echo "$(date '+%Y-%m-%d %H:%M:%S') - Checked disk usage for $TARGET_PATH: ${USAGE}%" >> logs/diagnostic.log

if [ "$USAGE" -ge "$THRESHOLD" ]; then
    exit 1
else
    exit 0
fi