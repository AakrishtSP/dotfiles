function backup --argument filename
    # Input validation
    if test -z "$filename"
        echo "Error: backup requires a filename argument"
        return 1
    end
    
    if not test -f "$filename"
        echo "Error: '$filename' is not a regular file"
        return 1
    end
    
    # Check if backup already exists to avoid overwriting
    if test -f "$filename.bak"
        echo "Warning: '$filename.bak' already exists. Do you want to overwrite it? [y/N]"
        read -l confirm
        if test "$confirm" != "y" -a "$confirm" != "Y"
            echo "Backup cancelled"
            return 1
        end
    end
    
    cp "$filename" "$filename.bak"
end