-- Permissions. Globs from the old config converted to RegEx (* -> .*).
-- Changes here require a Hyprland restart (not applied on reload), by design.

hl.config({ ecosystem = { enforce_permissions = true } })

hl.permission("/usr/bin/.*",  "screencopy", "ask")
hl.permission("/usr/bin/grim", "screencopy", "allow")
hl.permission("/usr/bin/hyprlock", "screencopy", "allow")
hl.permission("/usr/bin/discord", "screencopy", "ask")
hl.permission("/usr/bin/zen-browser", "screencopy", "ask")
hl.permission("/usr/bin/obs", "screencopy", "ask")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")

hl.permission("/run/media/.*", "keyboard", "deny")
