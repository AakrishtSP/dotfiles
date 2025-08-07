# Replace ls with eza
if type -q eza
    alias ls 'eza -al --color=always --group-directories-first --icons' # preferred listing
    alias la 'eza -a --color=always --group-directories-first --icons'  # all files and dirs
    alias ll 'eza -l --color=always --group-directories-first --icons'  # long format
    alias lt 'eza -aT --color=always --group-directories-first --icons' # tree listing
    alias l. 'eza -ald --color=always --group-directories-first --icons .*' # show only dotfiles
end
# Replace some more things with better alternatives
if type -q bat
    alias cat 'bat --style header --style snip --style changes --style header'
end

# Common use
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias ...... 'cd ../../../../..'
alias dir 'dir --color=auto'
alias psmem 'ps auxf | sort -nr -k 4'
alias psmem10 'ps auxf | sort -nr -k 4 | head -10'
alias wget 'wget -c '

# Conditional aliases based on available tools
if type -q expac
    alias big 'expac -H M "%m\t%n" | sort -h | nl'     # Sort installed packages according to size in MB
    alias rip 'expac --timefmt="%Y-%m-%d %T" "%l\t%n %v" | sort | tail -200 | nl' # Recent installed packages
end

if type -q ugrep
    alias grep 'ugrep --color=auto'
    alias egrep 'ugrep -E --color=auto'
    alias fgrep 'ugrep -F --color=auto'
else if type -q grep
    alias grep 'grep --color=auto'
    alias egrep 'egrep --color=auto'
    alias fgrep 'fgrep --color=auto'
end

if type -q ip
    alias ip 'ip -color'
end

## Useful aliases
if type -q update-grub
    if type -q sudo
        alias grubup 'sudo update-grub'
    else
        alias grubup 'update-grub'
    end
else if type -q grub-mkconfig
    alias update-grub 'grub-mkconfig -o /boot/grub/grub.cfg'

    alias grubup 'sudo grub-mkconfig -o /boot/grub/grub.cfg'
end

if type -q hwinfo
    alias hw 'hwinfo --short'                          # Hardware Info
end

if type -q journalctl
    alias jctl 'journalctl -p 3 -xb' # Get the error messages from journalctl
end