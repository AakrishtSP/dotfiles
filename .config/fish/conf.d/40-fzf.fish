# FZF key bindings for Fish

# Search directory (Ctrl+Alt+f)
bind \cf 'fzf_cd'
function fzf_cd
    set -l dir (find . -type d 2> /dev/null | fzf --height 40% --reverse --tac)
    if test -n "$dir"
        cd "$dir"
    end
end

# History search (Ctrl+R)
bind \cr 'fzf_history'
function fzf_history
    commandline (builtin history | fzf --height 40% --reverse --tac)
    commandline -f repaint
end

# File insert (Ctrl+T)
bind \ct 'fzf_file_insert'
function fzf_file_insert
    set -l file (fzf --height 40% --reverse --tac)
    if test -n "$file"
        commandline --insert "$file"
    end
end
# Directory insert (Ctrl+D)
bind \cd 'fzf_dir_insert'
function fzf_dir_insert
    set -l dir (find . -type d 2> /dev/null | fzf --height 40% --reverse --tac)
    if test -n "$dir"
        commandline --insert "$dir"
    end
end

abbr --add zz 'zoxide query -i | read -l dir; and cd "$dir"'
