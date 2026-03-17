# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Hyprflow is a dotfiles repository for a Hyprland Wayland compositor setup, structured for GNU Stow deployment. All packages mirror the path relative to `$HOME` and are deployed with `stow -t ~`.

## Deployment

```bash
# User configs
stow -t ~ hypr kitty rofi waybar yazi wlogout zsh starship swaync

# Remove symlinks
stow -t ~ -D hypr
```

## Hypr config structure

The entry point is `hypr/.config/hypr/hyprland.conf` — it only `source =`s other files and contains system-level blocks (`xwayland`, `ecosystem`).

| File                            | Purpose                                                                                           |
| ------------------------------- | ------------------------------------------------------------------------------------------------- |
| `themes/catppuccin-frappe.conf` | Color variable definitions (`$mauve`, `$blue`, etc.)                                              |
| `variables.conf`                | App variables (`$terminal`, `$fileManager`)                                                       |
| `aesthetics.conf`               | **All visual config**: `general`, `decoration`, `animations`, `group`, `render`, `cursor`, `misc` |
| `input.conf`                    | `input`, `gestures`, per-device config                                                            |
| `monitors.conf`                 | Monitor layout and workspace assignments                                                          |
| `binds.conf`                    | `binds {}` settings block + all keybindings                                                       |
| `windowrules.conf`              | `windowrulev2` rules                                                                              |
| `autostart.conf`                | `exec-once` startup commands                                                                      |
| `env.conf`                      | Environment variables                                                                             |

**Rule**: all color references use theme variables (e.g. `$mauve`, `$surface0`) — never hardcode colors except in the theme file itself. All visual/display settings belong in `aesthetics.conf`.
