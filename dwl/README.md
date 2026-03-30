# dwl

A customized build of [dwl](https://codeberg.org/dwl/dwl) — a compact, hackable Wayland compositor based on wlroots.

## Patches Applied

- **bar** — dwm-style status bar via drwl
- **barcolors** — `^fg()`/`^bg()` color markup in status text
- **vanitygaps** — inner/outer gaps with runtime keybindings
- **rotate-clients** — rotate tiled clients in the stack
- **customfloat** — set floating window size/position via rules

## Dependencies

### Build

| Package | Notes |
|---|---|
| `wlroots` | 0.19.x required |
| `wayland` | |
| `wayland-protocols` | |
| `xkbcommon` | |
| `libinput` | |
| `pixman` | Required by bar patch |
| `fcft` | Required by bar patch |
| `tllist` | Required by fcft |

On Arch Linux:
```
sudo pacman -S wlroots wayland wayland-protocols libxkbcommon libinput pixman fcft tllist
```

### Runtime

| Package | Purpose |
|---|---|
| `foot` | Default terminal |
| `rofi` | App launcher (`Super+Space`) |
| `swaybg` | Wallpaper (`start.sh`) |
| `mako` | Notifications |
| `impala` | WiFi TUI (`Super+Ctrl+W`) |
| `brave` | Browser (`Super+Ctrl+B`) |
| `iwd` / `iw` | WiFi info in status bar |

On Arch Linux:
```
sudo pacman -S foot rofi swaybg mako impala iwd
```
Brave is available in the AUR: `yay -S brave-bin`

## Building

```sh
cp config.def.h config.h   # only needed first time or after config changes
make
```

## Running

Use the provided start script from a TTY:

```sh
./start.sh
```

This pipes the status bar script into dwl and launches `swaybg`, `mako`, and `foot` on startup.

## Keybindings

`MODKEY` is the Super (Windows) key.

### Applications
| Binding | Action |
|---|---|
| `Super+Return` | Terminal (foot) |
| `Super+Space` | App launcher (rofi) |
| `Super+Ctrl+B` | Browser (brave) |
| `Super+Ctrl+W` | WiFi TUI (impala) |

### Windows
| Binding | Action |
|---|---|
| `Super+j/k` | Focus next/prev window |
| `Super+Shift+j/k` | Rotate clients in stack |
| `Super+Shift+Return` | Zoom (promote to master) |
| `Super+Shift+c` | Kill focused window |
| `Super+Shift+f` | Toggle floating |
| `Super+e` | Toggle fullscreen |
| `Super+h/l` | Adjust master width |
| `Super+i/d` | Inc/dec master count |

### Layouts
| Binding | Action |
|---|---|
| `Super+t` | Tile |
| `Super+f` | Float |
| `Super+m` | Monocle |
| `Super+Shift+Space` | Toggle previous layout |

### Gaps
| Binding | Action |
|---|---|
| `Super+Alt+h/l` | Increase/decrease all gaps |
| `Super+Alt+Shift+H/L` | Increase/decrease outer gaps |
| `Super+Alt+Ctrl+h/l` | Increase/decrease inner gaps |
| `Super+Alt+0` | Toggle gaps |
| `Super+y/o` | Inner horizontal gaps |
| `Super+Ctrl+y/o` | Inner vertical gaps |
| `Super+Alt+y/o` | Outer horizontal gaps |
| `Super+Shift+Y/O` | Outer vertical gaps |

### Bar & Monitors
| Binding | Action |
|---|---|
| `Super+b` | Toggle bar |
| `Super+,/.` | Focus monitor left/right |
| `Super+Shift+</> ` | Move window to monitor |

### Tags
| Binding | Action |
|---|---|
| `Super+1-9` | Switch to tag |
| `Super+Ctrl+1-9` | Toggle tag view |
| `Super+Shift+1-9` | Move window to tag |
| `Super+0` | View all tags |

### System
| Binding | Action |
|---|---|
| `Super+Shift+q` | Quit dwl |
| `Ctrl+Alt+Backspace` | Quit dwl |
| `Ctrl+Alt+F1-F12` | Switch VTY |
