#!/bin/bash

GOLDEN="../golden"
SERVERS="../servers"
REPORT="../reports/drift_report.txt"

echo "=====================================" | tee "$REPORT"
echo "       CONFIG DRIFT REPORT" | tee -a "$REPORT"
echo "=====================================" | tee -a "$REPORT"
echo "Date: $(date)" | tee -a "$REPORT"
echo | tee -a "$REPORT"

for server in "$SERVERS"/*; do

    server_name=$(basename "$server")

    echo "-------------------------------------" | tee -a "$REPORT"
    echo "Server: $server_name" | tee -a "$REPORT"
    echo "-------------------------------------" | tee -a "$REPORT"

    for golden_file in "$GOLDEN"/*; do

        filename=$(basename "$golden_file")
        server_file="$server/$filename"

        echo | tee -a "$REPORT"
        echo "Configuration: $filename" | tee -a "$REPORT"

        if [ ! -f "$server_file" ]; then
            echo "Status: MISSING" | tee -a "$REPORT"
            continue
        fi

        golden_hash=$(sha256sum "$golden_file" | awk '{print $1}')
        server_hash=$(sha256sum "$server_file" | awk '{print $1}')

        if [ "$golden_hash" = "$server_hash" ]; then
            echo "Status: COMPLIANT" | tee -a "$REPORT"
        else
            echo "Status: DRIFT DETECTED" | tee -a "$REPORT"
            echo "Golden Hash: $golden_hash" | tee -a "$REPORT"
            echo "Server Hash: $server_hash" | tee -a "$REPORT"
        fi

    done

done

echo | tee -a "$REPORT"
echo "=====================================" | tee -a "$REPORT"
echo "          CHECK COMPLETE" | tee -a "$REPORT"
echo "=====================================" | tee -a "$REPORT"
echo "Report saved to: $REPORT"
