## Starship prompt
if status --is-interactive; and type -q starship
    # Initialize starship prompt for the current shell session
    source (starship init fish --print-full-init | psub)
end