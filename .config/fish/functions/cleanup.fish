# Cleanup local orphaned packages
function cleanup
    if type -q pacman
        # Arch-based systems (including Garuda)
        set orphaned_pkgs (pacman -Qdtq 2>/dev/null)
        
        if test -z "$orphaned_pkgs"
            echo "No orphaned packages found"
            return 0
        end
        
        echo "Found orphaned packages: $orphaned_pkgs"
        echo "Remove these packages? [y/N]"
        read -l confirm
        
        if test "$confirm" = "y" -o "$confirm" = "Y"
            for pkg in $orphaned_pkgs
                echo "Removing $pkg..."
                if type -q sudo
                    sudo pacman -R "$pkg"
                else
                    pacman -R "$pkg"
                end
            end
        else
            echo "Cleanup cancelled"
        end
    else if type -q apt
        # Debian-based systems
        echo "Cleaning up orphaned packages with apt..."
        if type -q sudo
            sudo apt autoremove
        else
            apt autoremove
        end
    else if type -q pkg
        # Termux
        echo "Cleaning up orphaned packages with pkg..."
        pkg autoremove
    else
        echo "No supported package manager found (pacman, apt, or pkg)"
        return 1
    end
end
