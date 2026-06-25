#!/usr/bin/env bash
# Float secondary Zen windows (popups, OAuth, sign-in).
# First zen window = main browser, stays tiled.
# Subsequent popup windows = float + center. Tab tear-off is a known false positive.

SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

zen_count() {
  hyprctl clients -j | grep -c '"class": "zen"'
}

socat -U - "UNIX-CONNECT:$SOCK" | while IFS= read -r line; do
  case $line in
    openwindow\>\>*)
      payload=${line#openwindow>>}
      IFS=',' read -r addr workspace class title <<<"$payload"
      [[ $class == zen ]] || continue
      # window.open popups (OAuth/sign-in) open with an empty title.
      # Normal windows and torn-off tabs open with the page title.
      [[ -z $title ]] || continue

      # New window already counted in clients. >1 means a main exists.
      if (( $(zen_count) > 1 )); then
        hyprctl dispatch setfloating "address:0x$addr" >/dev/null
        hyprctl dispatch resizewindowpixel "exact 1000 700,address:0x$addr" >/dev/null
        hyprctl dispatch centerwindow >/dev/null
      fi
      ;;
  esac
done
