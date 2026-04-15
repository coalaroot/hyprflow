#!/bin/bash
STATE="/tmp/waybar_timers"

input=$(rofi -dmenu -p "󱑂 New timer" \
    -theme-str 'window { width: 400px; } listview { lines: 0; } inputbar { padding: 8px 8px; } entry { placeholder: "15min deep work"; }' \
    < /dev/null)
# Cancelled (Escape) = rofi exits non-zero; empty input = use default
[ $? -ne 0 ] && exit 0
[ -z "$input" ] && input="15m deep work"

# First word = duration, rest = optional label
read -r duration label <<< "$input"

seconds=$(python3 -c "
import re, sys
s = sys.argv[1].strip()
total = 0
matched = False
for m in re.finditer(r'(\d+)\s*([hms]?)', s):
    val, unit = int(m.group(1)), m.group(2)
    if not val:
        continue
    matched = True
    if unit == 'h':
        total += val * 3600
    elif unit == 'm':
        total += val * 60
    else:
        total += val
if not matched or total <= 0:
    sys.exit(1)
print(total)
" "$duration" 2>/dev/null)

if [ $? -ne 0 ] || [ -z "$seconds" ]; then
    notify-send "Timer" "Invalid duration: $duration"
    exit 1
fi

end=$(($(date +%s) + seconds))

(
    sleep "$seconds"
    if grep -q "^${end}|" "$STATE" 2>/dev/null; then
        if [ -n "$label" ]; then
            notify-send -u critical "Timer: ${label}"
        else
            notify-send -u critical "Timer done!"
        fi
        for i in 1 2 3; do
            paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null
        done
        sed -i "/^${end}|/d" "$STATE"
    fi
) &
notifier_pid=$!

echo "${end}|${notifier_pid}|${label}" >> "$STATE"
