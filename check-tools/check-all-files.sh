
#!/usr/bin/env bash

set -u

ROOT_DIR="${1:?Usage: check-all-files.sh PROJECT_ROOT LOG_FILE}"
LOG_FILE="${2:?Usage: check-all-files.sh PROJECT_ROOT LOG_FILE}"
CONFIG_FILE="${ROOT_DIR}/check-tools/exemptions.conf"

ERROR_COUNT=0
FILE_COUNT=0
SKIP_COUNT=0

log()
{
    echo "$*" | tee -a "$LOG_FILE"
}

get_exemptions()
{
    local target="$1"
    local result=""

    [[ -f "$CONFIG_FILE" ]] || {
        echo ""
        return
    }

    while IFS='|' read -r pattern checks || [[ -n "$pattern" ]]; do
        [[ -z "$pattern" || "$pattern" =~ ^[[:space:]]*# ]] && continue

        pattern="${pattern#"${pattern%%[![:space:]]*}"}"
        pattern="${pattern%"${pattern##*[![:space:]]}"}"
        checks="${checks//[[:space:]]/}"

        if [[ "$target" == $pattern ]]; then
            if [[ "$checks" == "all" ]]; then
                echo "all"
                return
            fi

            result="${result},${checks}"
        fi
    done < "$CONFIG_FILE"

    echo "$result"
}

log "============================================================"
log "BuildingFramework File Format Check"
log "Project: ${ROOT_DIR}"
log "Time: $(date '+%Y-%m-%d %H:%M:%S')"
log "============================================================"

while IFS= read -r -d '' file; do

    relative_path="${file#${ROOT_DIR}/}"
    FILE_COUNT=$((FILE_COUNT + 1))

    exemptions="$(get_exemptions "$relative_path")"

    if [[ "$exemptions" == "all" ]]; then
        SKIP_COUNT=$((SKIP_COUNT + 1))
        log "[SKIP] ${relative_path} (all)"
        continue
    fi

    if python3 - "$file" <<'PY'
import sys

with open(sys.argv[1], "rb") as f:
    data = f.read()

sys.exit(0 if b"\0" in data else 1)
PY
    then
        SKIP_COUNT=$((SKIP_COUNT + 1))
        log "[SKIP] ${relative_path} (binary file)"
        continue
    fi

    result="$(
        python3 - "$file" "$exemptions" <<'PY'
import sys
import re

path = sys.argv[1]
exemptions = sys.argv[2].split(",")

def exempt(name):
    return name in exemptions or "all" in exemptions

errors = []

try:
    with open(path, "rb") as f:
        data = f.read()
except Exception as e:
    print("READ_ERROR: " + str(e))
    sys.exit(0)

content = None

# UTF-8 validation
try:
    content = data.decode("utf-8", errors="strict")

    if content.startswith("\ufeff") and not exempt("format"):
        errors.append("FORMAT_ERROR: UTF-8 BOM detected")

except UnicodeDecodeError as e:
    if not exempt("format"):
        errors.append("UTF8_ERROR: invalid UTF-8 at byte {}".format(e.start))

# LF line ending validation
if not exempt("format"):
    if b"\r\n" in data:
        errors.append("FORMAT_ERROR: CRLF line ending detected")

    if re.search(rb"\r(?!\n)", data):
        errors.append("FORMAT_ERROR: CR line ending detected")

# Chinese character validation
if content is not None and not exempt("charset"):
    chinese = re.search(
        r"[\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff"
        r"\U00020000-\U0002fa1f]",
        content
    )

    if chinese:
        line = content[:chinese.start()].count("\n") + 1
        errors.append(
            "CHINESE_ERROR: Chinese character at line {}".format(line)
        )

# Trailing blank line validation
if not exempt("blank"):
    lines = data.split(b"\n")

    if lines and lines[-1] == b"":
        lines.pop()

    trailing = 0

    for line in reversed(lines):
        if line.strip(b" \t\r") == b"":
            trailing += 1
        else:
            break

    if trailing:
        errors.append(
            "BLANK_ERROR: {} trailing blank line(s)".format(trailing)
        )

for error in errors:
    print(error)

PY
    )"

    if [[ -n "$result" ]]; then
        while IFS= read -r error; do
            [[ -z "$error" ]] && continue
            log "[ERROR] ${relative_path}: ${error}"
            ERROR_COUNT=$((ERROR_COUNT + 1))
        done <<< "$result"
    else
        log "[PASS] ${relative_path}"
    fi

done < <(
    find "$ROOT_DIR" \
        -type d \( -name .git -o -name tmp \) -prune -o \
        -type f -print0
)

log ""
log "============================================================"
log "CHECK SUMMARY"
log "============================================================"
log "Total files : ${FILE_COUNT}"
log "Skipped     : ${SKIP_COUNT}"
log "Error count : ${ERROR_COUNT}"

if [[ "$ERROR_COUNT" -eq 0 ]]; then
    log "RESULT      : PASS"
else
    log "RESULT      : FAIL"
fi

log "============================================================"

[[ "$ERROR_COUNT" -eq 0 ]]
