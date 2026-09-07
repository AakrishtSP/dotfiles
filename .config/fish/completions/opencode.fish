# ~/.config/fish/completions/opencode.fish
function __opencode_complete
    set -l tokens (commandline -opc)   # completed tokens up to the cursor
    set -l cur (commandline -ct)       # the token you're currently typing
    opencode --get-yargs-completions $tokens $cur
end
complete -c opencode -f -a '(__opencode_complete)'
