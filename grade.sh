#!/usr/bin/env bash

set -eo pipefail

echo "=== Starting Assignment 1 Local Grader ==="
SCORE=0
TOTAL=100

# 1. Required Files Check (10 points)
echo "[*] Checking required files..."
REQUIRED_FILES=("system-info.sh" "disk-check.sh" "network-check.sh" "README.md" "logs/.gitkeep")
MISSING=0
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -e "$file" ]; then
        echo "  [-] Missing required file: $file"
        MISSING=1
    fi
done

if [ "$MISSING" -eq 0 ]; then
    echo "  [+] All required files present."
    SCORE=$((SCORE + 10))
else
    echo "  [-] Some required files are missing."
fi

# 2. Bash Syntax Check (15 points)
echo "[*] Checking Bash syntax..."
SYNTAX_FAIL=0
for script in system-info.sh disk-check.sh network-check.sh; do
    if [ -f "$script" ]; then
        if bash -n "$script"; then
            echo "  [+] Syntax OK: $script"
        else
            echo "  [-] Syntax error in $script"
            SYNTAX_FAIL=1
        fi
    fi
done
if [ "$SYNTAX_FAIL" -eq 0 ]; then
    SCORE=$((SCORE + 15))
fi

# 3. Executable Permissions Check (10 points)
echo "[*] Checking executable permissions..."
PERM_FAIL=0
for script in system-info.sh disk-check.sh network-check.sh; do
    if [ -f "$script" ] && [ ! -x "$script" ]; then
        echo "  [-] Not executable: $script"
        PERM_FAIL=1
    fi
done
if [ "$PERM_FAIL" -eq 0 ]; then
    echo "  [+] All scripts have executable permissions."
    SCORE=$((SCORE + 10))
else
    echo "  [-] Run 'chmod +x *.sh' to fix permissions."
fi

# 4. Script Execution & Validation (40 points)
echo "[*] Testing script executions..."

# Test system-info.sh
if ./system-info.sh > /dev/null 2>&1; then
    echo "  [+] system-info.sh executed successfully."
    SCORE=$((SCORE + 15))
else
    echo "  [-] system-info.sh failed to execute."
fi

# Test disk-check.sh argument validation
if ./disk-check.sh invalid_threshold > /dev/null 2>&1; then
    # Should exit non-zero for invalid input
    EXIT_CODE=$?
    if [ "$EXIT_CODE" -eq 2 ]; then
        echo "  [+] disk-check.sh correctly handled invalid input with exit code 2."
        SCORE=$((SCORE + 15))
    else
        echo "  [-] disk-check.sh returned exit code $EXIT_CODE for invalid input (expected 2)."
    fi
else
    echo "  [+] disk-check.sh handled invalid input."
    SCORE=$((SCORE + 15))
fi

# Test network-check.sh
if ./network-check.sh 127.0.0.1 > /dev/null 2>&1; then
    echo "  [+] network-check.sh executed successfully."
    SCORE=$((SCORE + 10))
else
    echo "  [-] network-check.sh execution failed."
fi

# 5. Git History Check (15 points)
echo "[*] Checking Git history..."
COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo 0)
if [ "$COMMIT_COUNT" -ge 5 ]; then
    echo "  [+] Commit count check passed ($COMMIT_COUNT commits found)."
    SCORE=$((SCORE + 15))
else
    echo "  [-] Found $COMMIT_COUNT commits. Brief requires at least 5 meaningful commits."
fi

# 6. README Check (10 points)
if [ -s README.md ]; then
    echo "  [+] README.md is not empty."
    SCORE=$((SCORE + 10))
else
    echo "  [-] README.md is missing or empty."
fi

echo "=== Local Grading Complete ==="
echo "Estimated Local Score: $SCORE / $TOTAL"