## Advanced command-not-found hook
# Check for various command-not-found implementations
if test -f /usr/share/doc/find-the-command/ftc.fish -a -r /usr/share/doc/find-the-command/ftc.fish
    # Arch-based systems with find-the-command
    source /usr/share/doc/find-the-command/ftc.fish
else if test -f /etc/profile.d/command-not-found.fish -a -r /etc/profile.d/command-not-found.fish
    # Some Debian-based systems
    source /etc/profile.d/command-not-found.fish
end