## Set values
# Hide welcome message & ensure we are reporting fish as shell
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"

# Detect OS for conditional configuration
set -g OS_TYPE unknown
if test -f /data/data/com.termux/files/usr/bin/fish
    set -g OS_TYPE termux
else if test -f /etc/os-release
    set distro_id (grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
    switch $distro_id
        case arch manjaro garuda
            set -g OS_TYPE arch
        case debian ubuntu
            set -g OS_TYPE debian
        case '*'
            set -g OS_TYPE linux
    end
else if test (uname) = Darwin
    set -g OS_TYPE macos
end

# Set MANPAGER only if bat is available
if type -q bat
    set -xU MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -xU MANROFFOPT "-c"
end

if type -q fzf
    set -xU FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
    set -xU FZF_CTRL_T_COMMAND "fd --type f --hidden --follow --exclude .git"
    set -xU FZF_DEFAULT_OPTS "--height 40% --reverse --tac"
end

# Set SHELL path based on OS and available fish installation
if test -x /usr/bin/fish
    set -x SHELL /usr/bin/fish
else if test -x /data/data/com.termux/files/usr/bin/fish
    set -x SHELL /data/data/com.termux/files/usr/bin/fish
else if type -q fish
    set -x SHELL (type -p fish)
end

## Export variable need for qt-theme
if type "qtile" >> /dev/null 2>&1
   set -x QT_QPA_PLATFORMTHEME "qt5ct"
end

# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low


## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
# Only source if file exists and is readable by current user
if test -f ~/.fish_profile -a -r ~/.fish_profile
        source ~/.fish_profile
else if test -f ~/.fish_profile
    echo "Warning: ~/.fish_profile exists but is not readable, skipping"
end

# Load environment variables from ~/.config/.env
# This file should contain key=value pairs, one per line
# Lines starting with # are ignored, empty lines are skipped
# Variables can be expanded, e.g., PATH="$HOME/bin:$PATH"
# This is a simple parser, it does not handle complex cases like multi-line values or escaped

# if test -f ~/.config/.env
#     for line in (grep -v '^\s*#' ~/.config/.env | grep -v '^\s*$')
#         # Split at first =
#         set key (string split -m 1 '=' $line)[1]
#         set val (string split -m 1 '=' $line)[2]
#
#         # Expand variables manually for PATH or others if needed
#         # This example handles $HOME and $PATH expansion in val
#         if string match -q '*$HOME*' $val
#             set val (string replace '$HOME' $HOME $val)
#         end
#         if string match -q '*$PATH*' $val
#             set val (string replace '$PATH' $PATH $val)
#         end
#
#         # Remove surrounding quotes if present (e.g., "...")
#         if string match -qr '^".*"$' $val
#             set val (string trim $val '"')
#         end
#
#         # Export
#         set -gx $key $val
#     end
# end
