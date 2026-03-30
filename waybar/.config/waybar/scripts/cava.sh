#!/bin/bash
# Reads cava raw output and converts to Unicode bar characters for waybar.
# Hidden when MPD is not playing.

CHARS='▁▂▃▄▅▆▇█'
state="stopped"
frame=0

while IFS= read -r line; do
    # Check MPD state once per second (every 20 frames)
    if (( frame % 20 == 0 )); then
        state=$(mpc status 2>/dev/null | grep -oP '\[playing\]|\[paused\]' | tr -d '[]')
    fi
    (( frame++ ))

    if [[ "$state" == "playing" ]]; then
        out=""
        IFS=';' read -ra vals <<< "$line"
        for v in "${vals[@]}"; do
            v="${v//[^0-9]/}"
            [[ -z "$v" ]] && continue
            (( v > 7 )) && v=7
            out+="${CHARS:$v:1}"
        done
        [[ -n "$out" ]] && printf '{"text":"%s","tooltip":false}\n' "$out"
    else
        printf '{"text":"","tooltip":false}\n'
    fi
done < <(cava -p ~/.config/cava/config 2>/dev/null)
