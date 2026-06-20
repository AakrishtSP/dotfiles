# Add ~/.local/bin to PATH (with security checks)
if test -d ~/.local/bin
    # For Termux, ownership check might not work as expected
    if test "$OS_TYPE" = termux; or test -O ~/.local/bin
        if not contains -- ~/.local/bin $PATH
            set -p PATH ~/.local/bin
        end
    else
        echo "Warning: ~/.local/bin exists but is not owned by current user, not adding to PATH"
    end
end

# Add ~/.local/scripts to PATH (with security checks)
if test -d ~/.local/scripts
    # For Termux, ownership check might not work as expected
    if test "$OS_TYPE" = termux; or test -O ~/.local/scripts
        if not contains -- ~/.local/scripts $PATH
            set -p PATH ~/.local/scripts
        end
    else
        echo "Warning: ~/.local/scripts exists but is not owned by current user, not adding to PATH"
    end
end


# Add andriod-ndk to paths
if test -d /opt/android-ndk
    if not contains -- /opt/android-ndk $PATH
        set -p PATH /opt/android-ndk
    end
end


# Add Termux-specific paths
if test "$OS_TYPE" = termux
    if test -d /data/data/com.termux/files/usr/bin
        if not contains -- /data/data/com.termux/files/usr/bin $PATH
            set -p PATH /data/data/com.termux/files/usr/bin
        end
    end
end
