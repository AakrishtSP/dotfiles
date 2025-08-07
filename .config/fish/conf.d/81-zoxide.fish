if status --is-interactive; and type -q zoxide
    # Initialize zoxide for the current shell session
    zoxide init --cmd cd fish | source
end