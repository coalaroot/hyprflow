#!/bin/bash
# Reads cava raw output and converts to Unicode bar characters for waybar

CHARS='▁▂▃▄▅▆▇█'

cava -p ~/.config/cava/config 2>/dev/null | while IFS= read -r line; do
    out=""
    IFS=';' read -ra vals <<< "$line"
    for v in "${vals[@]}"; do
        v="${v//[^0-9]/}"
        [[ -z "$v" ]] && continue
        (( v > 7 )) && v=7
        out+="${CHARS:$v:1}"
    done
    [[ -n "$out" ]] && printf '{"text":"%s","tooltip":false}\n' "$out"
done
