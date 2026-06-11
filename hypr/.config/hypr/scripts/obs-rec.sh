#!/usr/bin/env bash
# OBS record control over obs-websocket.
#
# Wayland forbids apps from grabbing global hotkeys, so OBS's own hotkeys only
# fire while OBS is focused. Hyprland binds ARE global, so we bind them to this
# script, which drives OBS over the websocket (obs-cli) regardless of focus.
#
# Requires: OBS → Tools → WebSocket Server Settings → "Enable WebSocket server".
# If authentication is on, export OBS_API_PASSWORD (see binds.conf note).
#
# Usage: obs-rec.sh [toggle|start|stop|status|pause|scene [N]]
#   scene      cycle to the next scene (wraps; good for a 2-scene setup)
#   scene N    switch to scene number N (1-based, in OBS list order)
set -euo pipefail

# Hyprland spawns binds with a minimal environment: ~/.local/bin (pipx's obs-cli)
# isn't on PATH, and shell-rc exports (the websocket password) aren't inherited.
# So make this script self-contained rather than rely on the launcher's env.
export PATH="$HOME/.local/bin:$PATH"
[ -f "$HOME/.config/hypr/obs.env" ] && set -a && . "$HOME/.config/hypr/obs.env" && set +a

action="${1:-toggle}"

notify() { command -v notify-send >/dev/null && notify-send -t 1800 -a OBS "$@" || true; }

case "$action" in
  pause)
    # record subcmd has no pause; trigger OBS's pause hotkey by id.
    if ! obs-cli hotkey trigger OBSBasic.PauseRecording >/dev/null 2>&1; then
      notify -u critical "OBS" "can't reach websocket — is the server enabled?"; exit 1
    fi
    notify "OBS" "⏸ pause toggled"
    ;;
  scene)
    if ! mapfile -t scenes < <(obs-cli scene list 2>/dev/null) || [ "${#scenes[@]}" -eq 0 ]; then
      notify -u critical "OBS" "can't reach websocket — is the server enabled?"; exit 1
    fi
    target="${2:-}"
    if [ -n "$target" ]; then
      # explicit 1-based index
      idx=$((target - 1))
    else
      # cycle: find current, pick next (wraps)
      current="$(obs-cli scene current 2>/dev/null)"
      idx=0
      for i in "${!scenes[@]}"; do
        [ "${scenes[$i]}" = "$current" ] && idx=$(((i + 1) % ${#scenes[@]})) && break
      done
    fi
    name="${scenes[$idx]:-}"
    if [ -z "$name" ]; then notify -u critical "OBS" "no scene at slot ${target:-?}"; exit 1; fi
    obs-cli scene switch -e "$name" >/dev/null 2>&1
    notify "OBS" "🎬 $name"
    ;;
  *)
    if ! out="$(obs-cli record "$action" 2>&1)"; then
      notify -u critical "OBS" "can't reach websocket — is the server enabled?"
      echo "$out" >&2; exit 1
    fi
    # Report resulting state (status lags the toggle by a tick — let it settle).
    sleep 0.4
    if obs-cli record status 2>/dev/null | grep -qiE 'started|true|active|recording'; then
      notify "OBS" "🔴 recording"
    else
      notify "OBS" "⏹ stopped"
    fi
    ;;
esac
