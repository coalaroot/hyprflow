#!/bin/bash

for i in 1 2 3 4 5; do
  DATA=$(curl -s --max-time 10 "wttr.in/?format=j1" 2>/dev/null)
  TEMP=$(echo "$DATA" | jq -r '.current_condition[0].temp_C // empty' 2>/dev/null)
  [ -n "$TEMP" ] && break
  [ "$i" -lt 5 ] && sleep 10
done

if [ -z "$TEMP" ]; then
  echo '{"text": "󰖑 N/A", "tooltip": "Weather unavailable"}'
  exit
fi

FEELS=$(echo "$DATA" | jq -r '.current_condition[0].FeelsLikeC')
DESC=$(echo "$DATA" | jq -r '.current_condition[0].weatherDesc[0].value')
HUMIDITY=$(echo "$DATA" | jq -r '.current_condition[0].humidity')
LOCATION=$(echo "$DATA" | jq -r '.nearest_area[0].areaName[0].value')
COUNTRY=$(echo "$DATA" | jq -r '.nearest_area[0].country[0].value')
MIN=$(echo "$DATA" | jq -r '.weather[0].mintempC')
MAX=$(echo "$DATA" | jq -r '.weather[0].maxtempC')

case "$DESC" in
  *"Sunny"*|*"Clear"*)           ICON="󰖙" ;;
  *"Partly"*)                    ICON="󰖕" ;;
  *"Cloud"*|*"Overcast"*)        ICON="󰖐" ;;
  *"Rain"*|*"Drizzle"*)          ICON="󰖗" ;;
  *"Snow"*|*"Blizzard"*)         ICON="󰖘" ;;
  *"Thunder"*|*"Lightning"*)     ICON="󰖓" ;;
  *"Fog"*|*"Mist"*|*"Haze"*)    ICON="󰖑" ;;
  *)                             ICON="󰖑" ;;
esac

TEXT="${ICON} ${TEMP}°C  ↓${MIN}° ↑${MAX}°"
TOOLTIP="${LOCATION}, ${COUNTRY}\n${DESC}\nFeels like: ${FEELS}°C\nHumidity: ${HUMIDITY}%"

printf '{"text": "%s", "tooltip": "%s"}\n' "$TEXT" "$TOOLTIP"
