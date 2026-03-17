#!/bin/bash

CAPACITY=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
STATUS=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)
PROFILE=$(powerprofilesctl get 2>/dev/null)

# Battery icon
if [ "$STATUS" = "Charging" ]; then
  BAT_ICON="󰂄"
elif [ "${CAPACITY:-0}" -ge 90 ]; then BAT_ICON="󰁹"
elif [ "${CAPACITY:-0}" -ge 70 ]; then BAT_ICON="󰂁"
elif [ "${CAPACITY:-0}" -ge 50 ]; then BAT_ICON="󰁾"
elif [ "${CAPACITY:-0}" -ge 30 ]; then BAT_ICON="󰁼"
elif [ "${CAPACITY:-0}" -ge 10 ]; then BAT_ICON="󰁺"
else                                    BAT_ICON="󰂎"
fi

# Profile icon
case "$PROFILE" in
  "performance") PROFILE_ICON="󱐋" ;;
  "balanced")    PROFILE_ICON="󰗑" ;;
  "power-saver") PROFILE_ICON="󰌪" ;;
  *)             PROFILE_ICON="?" ;;
esac

TEXT="${BAT_ICON} ${CAPACITY}% ${PROFILE_ICON}"
TOOLTIP="Battery: ${CAPACITY}% (${STATUS})\nProfile: ${PROFILE}\nClick to toggle profile"

printf '{"text": "%s", "tooltip": "%s"}\n' "$TEXT" "$TOOLTIP"
