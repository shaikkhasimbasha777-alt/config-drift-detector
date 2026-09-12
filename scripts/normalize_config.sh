#!/bin/bash

INPUT="$1"
OUTPUT="$2"

if [ -z "$INPUT" ] || [ -z "$OUTPUT" ]; then
    echo "Usage: $0 input_file output_file"
    exit 1
fi

sed \
    -e 's/[[:space:]]*=[[:space:]]*/=/g' \
    -e 's/^[[:space:]]*//' \
    -e 's/[[:space:]]*$//' \
    "$INPUT" |
    grep -v '^#' |
    grep -v '^$' |
    sort > "$OUTPUT"

echo "Normalized: $INPUT"
echo "Output:     $OUTPUT"
