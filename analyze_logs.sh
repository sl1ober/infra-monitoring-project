#!/bin/bash
 
set -e
 
LOG_FILE="logs/access.log"
mkdir -p logs
 
# Generate 300 test log entries
ips=(
    "192.168.1.10"
    "10.0.0.5"
    "192.168.1.20"
    "172.16.0.8"
    "192.168.1.10"
)
 
methods=("GET" "POST" "GET" "GET" "POST")
paths=("/api/users" "/api/login" "/api/products")
statuses=(200 200 404 500 401 200 403 200 503 201)
 
: > "$LOG_FILE"
 
for i in $(seq 1 300); do
    ip=${ips[$((i % ${#ips[@]}))]}
    method=${methods[$((i % ${#methods[@]}))]}
    path=${paths[$((i % ${#paths[@]}))]}
    status=${statuses[$((i % ${#statuses[@]}))]}
 
    printf '%s - - [15/Aug/2026:10:%02d:%02d] "%s %s HTTP/1.1" %s\n' \
        "$ip" "$(((i / 60) % 60))" "$((i % 60))" \
        "$method" "$path" "$status" >> "$LOG_FILE"
done
 
# Total number of requests
total=$(grep -Ec '^[0-9]{1,3}(\.[0-9]{1,3}){3} ' "$LOG_FILE")
 
echo "Общее количество запросов: $total"
 
# Top 3 IP addresses
echo
echo "Топ-3 IP-адреса по количеству запросов:"
grep -Eo '^[0-9]{1,3}(\.[0-9]{1,3}){3}' "$LOG_FILE" |
    sort |
    uniq -c |
    sort -nr |
    head -3
 
# Count 4xx and 5xx responses
errors_4xx=$(awk '$8 ~ /^4[0-9][0-9]$/ { count++ } END { print count+0 }' "$LOG_FILE")
errors_5xx=$(awk '$8 ~ /^5[0-9][0-9]$/ { count++ } END { print count+0 }' "$LOG_FILE")
 
echo
echo "Количество ответов 4xx: $errors_4xx"
echo "Количество ответов 5xx: $errors_5xx"
echo
echo "Журнал создан: $LOG_FILE"
