#!/bin/bash

# Path to vwtool
VWTOOL_PATH="*/IBM/FileNet/ContentEngine/tools/PE/vwtool"

# Select your dstination region
REGION="REG1_CP"

# For your envierment use environment variables or secure file, only purpose is to show how to work with this
USERNAME="xxx"
PASSWORD="xxx"

# Choose output file
OUTPUT_FILE="/var/log/app_metrics/queues_status.log"

log_msg() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$OUTPUT_FILE"
}

# Information to your outputFile
log_msg "Starting data collection from vwtool..."

# You can do it without timeout, its for keeping timing, if vwtool answearing too long, you will see in logs
vwtool_output=$(timeout 30s $VWTOOL_PATH $REGION -Y "$USERNAME+$PASSWORD" <<EOF 2>&1
count *
EOF
)

# Checking vwtool_output
if [[ $? -ne 0 ]]; then
    log_msg "ERROR: $vwtool_output"
    exit 1
fi

# Saving data to output file
echo "$vwtool_output" | grep -E "_Operations" >> $OUTPUT_FILE