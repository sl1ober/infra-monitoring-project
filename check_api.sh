#!/bin/bash
 
if [ -z "$1" ]; then
    echo "Использование: $0 <URL>"
    exit 1
fi
 
url="$1"
 
http_code=$(curl -sS -o /dev/null -w "%{http_code}" \
    --max-time 10 "$url" 2>/dev/null)
curl_status=$?
 
if [ "$curl_status" -ne 0 ]; then
    echo "API недоступен, код ответа: ${http_code:-000}"
    exit 1
fi
 
if [ "$http_code" -eq 200 ]; then
    echo "API доступен"
    exit 0
else
    echo "API недоступен, код ответа: $http_code"
    exit 1
fi
