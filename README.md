# hyprflow

Personal Hyprland dotfiles. Managed with GNU Stow.

## System

|                |                                                                                                                       |
| -------------- | --------------------------------------------------------------------------------------------------------------------- |
| **OS**         | Fedora Linux                                                                                                          |
| **Compositor** | Hyprland (Wayland)                                                                                                    |
| **Theme**      | <span style="color:#03edf9">Synth</span><span style="color:#ff6c11">wave</span> <span style="color:#ff7edb">84</span> |
| **Font**       | JetBrains Mono Nerd Font                                                                                              |

## Core

| Role                    | Tool            |
| ----------------------- | --------------- |
| Terminal                | Kitty           |
| Shell                   | Zsh             |
| Prompt                  | Starship        |
| Bar                     | Waybar          |
| Launcher                | Rofi            |
| Notifications           | Swaync          |
| Wallpaper               | Waypaper + swww |
| Display layout          | Kanshi          |
| Lock screen             | Hyprlock        |
| Logout menu             | Wlogout         |
| OSD (volume/brightness) | Swayosd         |
| Screenshots             | Hyprshot        |

## TUI

| Role         | Tool       |
| ------------ | ---------- |
| File manager | Yazi       |
| Audio mixer  | Pulsemixer |
| Bluetooth    | Bluetui    |

## GUI

| Role             | Tool          |
| ---------------- | ------------- |
| Browser          | Google Chrome |
| Code editor      | VSCode        |
| Network          | nm-applet     |
| Wallpaper picker | Waypaper      |
| Wallpaper daemon | swww          |
| Recording        | OBS           |
| 3D printing      | Bambu Studio  |
| Tasks            | TickTick      |

## CLI

| Role              | Tool                   |
| ----------------- | ---------------------- |
| Directory jumping | Zoxide                 |
| Media control     | Playerctl              |
| Volume / mute     | wpctl + swayosd-client |
| SSH keys          | Keychain               |

## Keybinds (SUPER + ...)

| Key       | Action                 |
| --------- | ---------------------- |
| `Q`       | Kill window            |
| `F`       | Fullscreen             |
| `V`       | Toggle floating        |
| `A`       | VSCode                 |
| `C`       | Chrome                 |
| `X`       | Terminal (projects)    |
| `E`       | Yazi file manager      |
| `M`       | Pulsemixer (float)     |
| `W`       | Rofi launcher          |
| `L`       | Wlogout                |
| `U`       | Waypaper               |
| `I`       | Switch keyboard layout |
| `N`       | Notification center    |
| `S`       | Screenshot window      |
| `SHIFT+S` | Screenshot region      |
| `Z`       | Scratchpad toggle      |

## Deployment

```bash
stow -t ~ hypr kitty rofi waybar yazi wlogout zsh starship
```
