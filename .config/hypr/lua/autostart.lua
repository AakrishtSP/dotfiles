-- Autostart. Runs once at launch (not on every config reload).
-- Dropped dead references from the old config: scripts/env.sh, exec-hyprland,
-- apply-gsettings (none exist on this system).

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Wallpaper (awww daemon + waypaper restores the last wallpaper)
    hl.exec_cmd("awww")
    hl.exec_cmd("waypaper --restore")

    -- Daemons / applets
    hl.exec_cmd("hypridle")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("kdeconnectd")
    hl.exec_cmd("kdeconnect-indicator")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("xrdb -load ~/.Xresources")

    -- Clipboard manager (cliphist)
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
