# Hyprland dotfiles — dependencies (Arch)

Packages referenced by this config (binds, autostart, rules, scripts) plus the
GPU/HDR stack for an AMD-primary + NVIDIA-secondary laptop.

## Official repos (pacman)

```bash
sudo pacman -S --needed \
  hyprland xdg-desktop-portal-hyprland hyprlock hypridle hyprpolkitagent \
  waybar swaync rofi ghostty dolphin \
  discord spotify-launcher \
  pamixer brightnessctl playerctl libnotify wl-clipboard cliphist \
  grim slurp blueman kdeconnect xorg-xrdb qt5ct \
  nwg-bar polkit dbus
```

## GPU + HDR drivers (AMD primary, NVIDIA offload)

```bash
# AMD (drives eDP + DP-2, handles HDR)
sudo pacman -S --needed mesa vulkan-radeon libva-mesa-driver vulkan-icd-loader

# NVIDIA (offload only). nvidia-open-dkms = Turing/RTX+; use nvidia-dkms for older.
sudo pacman -S --needed nvidia-open-dkms nvidia-utils libva-nvidia-driver \
  egl-wayland linux-headers

# optional: 32-bit (Steam/Wine) + diagnostics
sudo pacman -S --needed lib32-mesa lib32-vulkan-radeon lib32-nvidia-utils libva-utils
```

## AUR (yay / paru)

```bash
yay -S zen-browser-bin waypaper
```

- `zen-browser-bin` — `$browser`
- `waypaper` — wallpaper frontend (`waypaper --restore` / `--random`)
- `awww` — animated wallpaper daemon (already installed on this box; AUR). waypaper
  uses it as backend. If reinstalling: `yay -S awww` (or the `-git` variant).

## Notes

- `notify-send` ships with `libnotify`. `wl-copy`/`wl-paste` ship with
  `wl-clipboard`. `dbus-update-activation-environment` ships with `dbus`.
- Terminal is `ghostty` everywhere (scratchpad/special workspaces too). No `foot`.
  Clipboard menu uses `rofi -dmenu`. No `wofi`.
- `rofi` from extra is X11 (runs fine under XWayland). For native Wayland use
  AUR `rofi-wayland` instead — conflicts with `rofi`, pick one.
- HDR needs no extra package: Hyprland handles it. Just keep `bitdepth=10` +
  `cm="auto"` (already set) and a 10-bit-capable panel.
- After installing `nvidia-open-dkms`: enable DRM modeset (usually default now)
  and rebuild initramfs. Confirm both GPUs: `ls /dev/dri/by-path/` and
  `lspci -k | grep -EA3 'VGA|3D'`.
