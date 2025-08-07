if not test -x /usr/bin/yay; and test -x /usr/bin/paru
    alias yay 'paru'
end

if type -q paru
    alias yeet 'paru -Rns'
else if type -q yay
    alias yeet 'yay -Rns'
else if type -q pacman
    alias yeet 'sudo pacman -Rns'
else if type -q apt
    alias yeet 'sudo apt remove'
else if type -q pkg
    alias yeet 'pkg uninstall'
end


# OS and package manager specific aliases
if type -q pacman
    alias fixpacman 'sudo rm -i /var/lib/pacman/db.lck'
    alias gitpkg 'pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages
    alias rmpkg 'sudo pacman -Rns'
    
    if type -q reflector
        # Get fastest mirrors (Arch-based systems)
        alias mirror 'sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist'
        alias mirrora 'sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist'
        alias mirrord 'sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist'
        alias mirrors 'sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist'
    end
    
    if type -q meld
        alias pacdiff 'sudo -H DIFFPROG=meld pacdiff'
    end
else if type -q apt
    # Debian-based systems
    alias rmpkg 'sudo apt remove'
    alias fixapt 'sudo dpkg --configure -a'
    alias update 'sudo apt update && sudo apt upgrade'
else if type -q pkg
    # Termux
    alias rmpkg 'pkg uninstall'
    alias update 'pkg update && pkg upgrade'
    # Termux doesn't need sudo
    alias apt 'pkg'
end