# Assignment 1 - Linux Diagnostic Toolkit

A collection of Bash scripts designed for Linux system diagnostics, disk monitoring, and network checks.

## Required Structure
- `system-info.sh` - Displays host, user, OS, kernel, uptime, CPU, memory, and path details.
- `disk-check.sh` - Checks disk usage against a user-defined threshold (1-100)[span_2](start_span)[span_2](end_span).
- `network-check.sh` - Resolves hosts, displays interfaces, and checks optional TCP port connectivity[span_3](start_span)[span_3](end_span).
- `grade.sh` - Provided grading script.

## Usage
Make scripts executable:
\`\``bash
chmod +x *.sh
\`\``

Run system info:
\`\``bash
./system-info.sh
\`\``

Run disk check:
\`\``bash
./disk-check.sh 80 /
\`\``

Run network check:
\`\``bash
./network-check.sh 8.8.8.8 53
\`\``