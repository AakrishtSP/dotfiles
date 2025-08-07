complete -c pkg -n '__fish_use_subcommand' -f \
  -a "install upgrade update list search show uninstall autoclean autoremove clean" \
  -d "Termux package manager commands"

complete -c pkg -n '__fish_seen_subcommand_from install uninstall show' \
  -a "(pkg list-all | cut -d ' ' -f 1)" \
  -d "Package name"
