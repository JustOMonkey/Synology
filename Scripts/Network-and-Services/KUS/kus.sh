#!/bin/bash

usertotal=0
# Get the output of smbstatus -p
output=$(smbstatus -p)

# Extract all PIDs and usernames and store them in an array as key-value pairs
declare -A pid_username_map

while read -r line; do
    if [[ "$line" =~ ^[0-9]+ ]]; then
        pid=$(echo "$line" | awk '{print $1}')
        username=$(echo "$line" | awk '{print $2}')
        pid_username_map["$pid"]="$username"
    fi
done <<< "$output"

# Show people who have been killed
for pid in "${!pid_username_map[@]}"; do
    username="${pid_username_map[$pid]}"
    echo "PID processing: $pid, Username: $username"
    kill -9 $pid
    ((usertotal++))
done

# Show total sessions killed
echo "Total Kill Session(s) (SMB) : $usertotal User(s)."