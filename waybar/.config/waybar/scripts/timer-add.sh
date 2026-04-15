#!/bin/bash
STATE="/tmp/waybar_timers"

input=$(rofi -dmenu -p "󱑂 New timer" \
    -theme-str 'window { width: 400px; } listview { lines: 0; } inputbar { padding: 8px 8px; } entry { placeholder: "25:00 deep work"; }' \
    < /dev/null)
# Cancelled (Escape) = rofi exits non-zero; empty input = use default
[ $? -ne 0 ] && exit 0
[ -z "$input" ] && input="15m deep work"

# First word = duration, rest = optional label
read -r duration label <<< "$input"

seconds=$(python3 -c "
import re, sys
from datetime import datetime, timedelta
s = sys.argv[1].strip()

# Clock time: HH:MM or HH:MM:SS — count down to that time today (tomorrow if passed)
cm = re.match(r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$', s)
if cm:
    h, m, sc = int(cm.group(1)), int(cm.group(2)), int(cm.group(3) or 0)
    if 0 <= h <= 23 and 0 <= m <= 59 and 0 <= sc <= 59:
        now = datetime.now()
        target = now.replace(hour=h, minute=m, second=sc, microsecond=0)
        if target <= now:
            target += timedelta(days=1)
        print(int((target - now).total_seconds()))
        sys.exit(0)

# Unit format: 5m, 1h30m, 90s, 90 (plain = seconds)
total = 0
matched = False
for tok in re.finditer(r'(\d+)\s*([hms]?)', s):
    val, unit = int(tok.group(1)), tok.group(2)
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
