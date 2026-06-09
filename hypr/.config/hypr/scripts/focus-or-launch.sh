#!/bin/bash
# Usage: focus-or-launch.sh <window_class> <launch_command>
# If a window with CLASS is open, go to its workspace and focus it.
# Special workspaces are toggled (show/hide). Otherwise, run LAUNCH_COMMAND.

CLASS="$1"
CMD="$2"

NAME=$(hyprctl clients -j | jq -r ".[] | select(.class == \"$CLASS\") | .workspace.name" | head -1)

if [[ "$NAME" == special:* ]]; then
    hyprctl dispatch togglespecialworkspace "${NAME#special:}"
elif [[ -n "$NAME" ]]; then
    hyprctl dispatch focuswindow "class:^(${CLASS})$"
else
    bash -c "$CMD"
fi
