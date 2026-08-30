#!/bin/bash

TOOL=$1
REPORT=$2

shift 2


mkdir -p "$(dirname "$REPORT")"

echo "================================" > "$REPORT"
echo " Static Check: ${TOOL}" >> "$REPORT"
echo " Time: $(date)" >> "$REPORT"
echo "================================" >> "$REPORT"


"$@" >> "$REPORT" 2>&1

echo "" >> "$REPORT"
echo "================================" >> "$REPORT"

if grep -q "error:" "$REPORT"; then
    echo "RESULT: FAIL" >> "$REPORT"
    RESULT=1
else
    echo "RESULT: PASS" >> "$REPORT"
    RESULT=0
fi

echo "================================" >> "$REPORT"

cat "$REPORT"

exit 0