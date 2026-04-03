#!/bin/bash
# Usage: focus-or-launch.sh <window_class> <launch_command>
# If a window with CLASS is open, go to its workspace and focus it.
# Otherwise, run LAUNCH_COMMAND.

CLASS="$1"
CMD="$2"

WORKSPACE=$(hyprctl clients -j | jq -r ".[] | select(.class == \"$CLASS\") | .workspace.id" | head -1)

if [[ "$WORKSPACE" =~ ^[0-9]+$ ]]; then
    hyprctl dispatch workspace "$WORKSPACE"
    hyprctl dispatch focuswindow "class:^(${CLASS})$"
else
    bash -c "$CMD"
fi
