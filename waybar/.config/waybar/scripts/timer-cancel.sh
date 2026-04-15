#!/bin/bash
STATE="/tmp/waybar_timers"

[ ! -f "$STATE" ] || [ ! -s "$STATE" ] && exit 0

now=$(date +%s)
declare -A pid_map
items=()

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
        display="${label} — ${t}"
    else
        display="No label — ${t}"
    fi
    pid_map["$display"]="${end}|${pid}"
    items+=("$display")
done < "$STATE"

[ "${#items[@]}" -eq 0 ] && exit 0

selected=$(printf '%s\n' "${items[@]}" | rofi -dmenu -p "Cancel timer" \
    -theme-str 'window { width: 450px; } listview { lines: 5; scrollbar: false; columns: 1; } element { padding: 8px 12px; } element-icon { size: 0; } element-text { horizontal-align: 0; }')
[ -z "$selected" ] && exit 0

entry="${pid_map[$selected]}"
end=$(cut -d'|' -f1 <<< "$entry")
pid=$(cut -d'|' -f2 <<< "$entry")

kill "$pid" 2>/dev/null
sed -i "/^${end}|/d" "$STATE"
