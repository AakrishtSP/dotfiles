# Fish shell configuration file for abbreviations

# Abbreviations for common commands
abbr --add zz 'zoxide query -i | read -l dir; and cd "$dir"'
abbr --add tarnow 'tar -acf '
abbr --add untar 'tar -zxvf '
abbr --add tb 'nc termbin.com 9999'
# abbr --add fzf 'fzf --height 40% --reverse --tac'

# Abbreviations for frequently used directories
abbr --add home 'cd ~'
abbr --add docs 'cd ~/Documents'
abbr --add down 'cd ~/Downloads'
abbr --add desk 'cd ~/Desktop'
abbr --add conf 'cd ~/.config'

# Abbreviations for git commands
abbr --add gco 'git checkout'
abbr --add gcm 'git commit -m'
abbr --add gca 'git commit --amend'
abbr --add gpl 'git pull'
abbr --add gps 'git push'
abbr --add gst 'git status'

# Abbreviations for system commands
abbr --add up 'sudo pacman -Syu'
abbr --add fix 'sudo pacman -Scc && sudo pacman -Syyu'


