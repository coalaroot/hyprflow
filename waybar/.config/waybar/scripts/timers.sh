#!/bin/bash
STATE="/tmp/waybar_timers"

if [ ! -f "$STATE" ] || [ ! -s "$STATE" ]; then
    echo '{"text":"","class":"idle"}'
    exit 0
fi

now=$(date +%s)
parts=()

while IFS='|' read -r end pid label; do
    [[ -z "$end" || ! "$end" =~ ^[0-9]+$ ]] && continue
    remaining=$((end - now))
    (( remaining <= 0 )) && continue
    hrs=$((remaining / 3600))
    mins=$(( (remaining % 3600) / 60 ))
    secs=$((remaining % 60))
    if (( hrs > 0 )); then
        t="${hrs}h ${mins}min"
    else
        t="${mins}min ${secs}s"
    fi
    if [ -n "$label" ]; then
        parts+=("󱑂 ${t} ${label}")
    else
        parts+=("󱑂 ${t}")
    fi
done < "$STATE"

if [ "${#parts[@]}" -eq 0 ]; then
    echo '{"text":"","class":"idle"}'
    exit 0
fi

python3 -c "
import sys, json
parts = sys.argv[1:]
text = ' · '.join(parts)
print(json.dumps({'text': text, 'class': 'running'}))
" "${parts[@]}"
