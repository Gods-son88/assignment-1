#!/usr/bin/env bash
HOST=$1
PORT=$2

if [ -z "$HOST" ]; then
    echo "Error: Hostname or IP required." >&2
    exit 2
fi

RESOLVED=$(getent hosts "$HOST" | awk '{print $1}')
if [ -z "$RESOLVED" ]; then
    RESOLVED=$(ping -c 1 "$HOST" 2>/dev/null | head -n 1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' || echo "")
fi

if [ -z "$RESOLVED" ]; then
    echo "Error: Could not resolve host $HOST" >&2
    exit 2
fi

echo "Resolved address for $HOST: $RESOLVED"
ip -o addr show | awk '{print "Interface " $2 ": " $4}'

if [ -n "$PORT" ]; then
    if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
        echo "Error: Port must be between 1 and 65535." >&2
        exit 2
    fi
    if nc -z -w 2 "$HOST" "$PORT" &>/dev/null; then
        echo "TCP connectivity to $HOST:$PORT is SUCCESSFUL."
    else
        echo "TCP connectivity to $HOST:$PORT FAILED." >&2
        exit 1
    fi
fi

mkdir -p logs
echo "$(date '+%Y-%m-%d %H:%M:%S') - Checked network for host $HOST" >> logs/diagnostic.log