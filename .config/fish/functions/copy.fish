# Copy DIR1 DIR2
function copy
    # Input validation
    if test (count $argv) -lt 1
        echo "Error: copy requires at least one argument"
        return 1
    end
    
    set count (count $argv)
    if test "$count" = 2; and test -d "$argv[1]"
        # Validate source directory exists and is readable
        if not test -r "$argv[1]"
            echo "Error: Cannot read source directory '$argv[1]'"
            return 1
        end
        
        set from (string trim --right --chars=/ -- "$argv[1]")
        set to "$argv[2]"
        
        # Prevent copying to potentially dangerous locations
        if string match -q "/*" -- "$to"
            # Different dangerous paths based on OS
            if test "$OS_TYPE" = termux
                if string match -q "/data/data/com.termux/files/usr/bin/*" -- "$to"; or string match -q "/system/*" -- "$to"
                    echo "Error: Refusing to copy to system directory '$to'"
                    return 1
                end
            else
                if string match -q "/etc/*" -- "$to"; or string match -q "/usr/*" -- "$to"; or string match -q "/var/*" -- "$to"
                    echo "Error: Refusing to copy to system directory '$to'"
                    return 1
                end
            end
        end
        
        command cp -r "$from" "$to"
    else
        command cp $argv
    end
end
