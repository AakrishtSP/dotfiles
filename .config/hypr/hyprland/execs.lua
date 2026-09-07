local vars = require("variables")
local fn   = require("utils.functions")

hl.on("hyprland.start", function()
    hl.exec_cmd(
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY HYPRLAND_INSTANCE_SIGNATURE")
    -- hl.exec_cmd("systemctl --user start hyprland-session.target")

    -- Keyring and auth
    hl.exec_cmd("gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg")
    -- hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- Clipboard history
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Auto delete trash 30 days old
    hl.exec_cmd("trash-empty 30")

    -- Cursors
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme sweet-cursors")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")

    -- Forward bluetooth media commands to MPRIS
    hl.exec_cmd("mpris-proxy")

    -- Start shell
    hl.exec_cmd(vars.shellSpawner)

    -- UWSM
    hl.exec_cmd("uwsm finalize")

    -- ALT + TAB
    hl.exec_cmd("snappy-switcher --daemon")

    -- Apps
    hl.exec_cmd("kdeconnectd")
end)

-- Resizer listeners
local function apply_resizer_rules(win)
    local float_center = {
        hl.dsp.window.float({ action = "on", window = win }),
        hl.dsp.window.center({ window = win }),
    }
    local pip_actions = fn.move_actions(win) or {}

    -- Bitwarden
    fn.resizer(win, "Bitwarden", 20, 54, float_center, true, "class")                                       -- Native app
    fn.resizer(win, "^Extension: %(Bitwarden Password Manager%) %- Bitwarden", 20, 54, float_center, false) -- Firefox
    fn.resizer(win, "nngceckbapebfimnlniiiahkandclblb", 20, 54, float_center, true, "class")                -- Chromium
    fn.resizer(win, "Bitwarden - Vivaldi", 20, 54, float_center, true)


    -- Picture in picture
    fn.resizer(win, "Picture[- ]in[- ][Pp]icture", 0, 0, pip_actions, false)
end

hl.on("window.title", apply_resizer_rules)
hl.on("window.open", apply_resizer_rules)
