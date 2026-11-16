
#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

CHECK_SCRIPT="${SCRIPT_DIR}/check-all-files.sh"
LOG_DIR="${ROOT_DIR}/tmp/log"

# Create log directory automatically
mkdir -p "$LOG_DIR" || exit 1

TIME_TAG="$(date '+%Y%m%d-%H%M%S')"
LOG_FILE="${LOG_DIR}/check-log-${TIME_TAG}.log"

touch "$LOG_FILE" || exit 1

echo "Starting format check..."
echo "Project: ${ROOT_DIR}"
echo "Log: ${LOG_FILE}"
echo ""

if ! command -v python3 >/dev/null 2>&1; then
    echo "[ERROR] python3 is required"
    exit 1
fi

if [[ ! -f "$CHECK_SCRIPT" ]]; then
    echo "[ERROR] Missing check script: ${CHECK_SCRIPT}"
    exit 1
fi

if [[ ! -f "${SCRIPT_DIR}/exemptions.conf" ]]; then
    echo "[WARN] exemptions.conf not found"
fi

if bash "$CHECK_SCRIPT" "$ROOT_DIR" "$LOG_FILE"; then
    echo ""
    echo "[PASS] All format checks passed."
    echo "Log: ${LOG_FILE}"
    exit 0
else
    echo ""
    echo "[FAIL] Format check found errors."
    echo "Log: ${LOG_FILE}"
    exit 1
fi
