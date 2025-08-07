## Run fastfetch if session is interactive
if status --is-interactive && type -q fastfetch
    clear
    fastfetch --config neofetch.jsonc
end
