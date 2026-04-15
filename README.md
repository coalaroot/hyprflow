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

| Role                    | Tool                        |
| ----------------------- | --------------------------- |
| Terminal                | Kitty                       |
| Shell                   | Zsh                         |
| Prompt                  | Starship                    |
| Bar                     | Waybar                      |
| Launcher                | Rofi                        |
| Notifications           | Swaync                      |
| Wallpaper               | Waypaper + swww             |
| Display layout          | Kanshi                      |
| Display manager         | SDDM (sddm-astronaut-theme) |
| Lock screen             | Hyprlock                    |
| Logout menu             | Wlogout                     |
| OSD (volume/brightness) | Swayosd                     |
| Screenshots             | Hyprshot                    |

## TUI

| Role         | Tool       |
| ------------ | ---------- |
| File manager | Yazi       |
| Audio mixer  | Pulsemixer |
| Bluetooth    | Bluetui    |
| Music player | ncmpcpp    |

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
| Media control     | Playerctl + mpc        |
| Volume / mute     | wpctl + swayosd-client |
| SSH keys          | Keychain               |
| Music daemon      | MPD                    |
| Bar visualizer    | Cava                   |

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
| `SHIFT+M` | ncmpcpp (float)        |
| `R`       | Rofi launcher          |
| `W`       | Add timer              |
| `L`       | Wlogout                |
| `U`       | Waypaper               |
| `I`       | Switch keyboard layout |
| `N`       | Notification center    |
| `S`       | Screenshot window      |
| `SHIFT+S` | Screenshot region      |
| `Z`       | Scratchpad toggle      |

## Timer

Waybar widget with multiple concurrent timers. Background timers with notification + sound on completion.

| Action           | How                                                                                             |
| ---------------- | ----------------------------------------------------------------------------------------------- |
| Add timer        | `SUPER+W` or right-click Waybar widget                                                          |
| Cancel timer     | `SUPER+SHIFT+W` or left-click Waybar widget → pick from list                                    |
| Duration format  | `5m`, `1h30m`, `2m10s`, `90` (plain = seconds), `13:40` (clock time → counts down to that time) |
| Label (optional) | Space-separated after duration: `25m deep work`                                                 |

## Deployment

```bash
# Dependencies
sudo dnf install mpd mpc ncmpcpp cava

# User configs (~)
stow -t ~ hypr kitty rofi waybar yazi wlogout zsh starship swaync mpd ncmpcpp cava

# Create required dirs
mkdir -p ~/Music ~/.local/share/mpd/playlists
```

SDDM theme is installed separately via [sddm-astronaut-theme](https://github.com/keyitdev/sddm-astronaut-theme):

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"
```
