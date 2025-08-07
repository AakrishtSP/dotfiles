## Run fastfetch if session is interactive
if status --is-interactive && type -q fastfetch
    fastfetch --config neofetch.jsonc
end
