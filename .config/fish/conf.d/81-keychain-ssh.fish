## Starship prompt
if status --is-interactive; and type -q keychain
        keychain --eval --quiet ~/.ssh/id_ed25519 | source
end
