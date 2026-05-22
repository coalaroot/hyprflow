#!/usr/bin/env bash
# Float secondary Chrome windows (popups, OAuth, DevTools).
# First chrome window = main browser, stays tiled.
# Subsequent = float + center. Tab tear-off is a known false positive.

SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

chrome_count() {
  hyprctl clients -j | grep -c '"class": "google-chrome"'
}

socat -U - "UNIX-CONNECT:$SOCK" | while IFS= read -r line; do
  case $line in
    openwindow\>\>*)
      payload=${line#openwindow>>}
      IFS=',' read -r addr workspace class title <<<"$payload"
      [[ $class == google-chrome ]] || continue
      # Tab tear-off opens with the page title. Popups/OAuth open as "Untitled".
      [[ $title == Untitled* ]] || continue

      # New window already counted in clients. >1 means a main exists.
      if (( $(chrome_count) > 1 )); then
        hyprctl dispatch setfloating "address:0x$addr" >/dev/null
        hyprctl dispatch resizewindowpixel "exact 1000 700,address:0x$addr" >/dev/null
        hyprctl dispatch centerwindow >/dev/null
      fi
      ;;
  esac
done
