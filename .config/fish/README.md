# Portable Fish Shell Configuration

This is a portable Fish shell configuration that works across different Linux distributions and in Termux (Android). It automatically detects the environment and adapts accordingly.

## Features

- **Cross-platform compatibility**: Works on Arch Linux, Ubuntu, Debian, Termux, and other distributions
- **Automatic environment detection**: Adapts package manager aliases and paths based on the detected system
- **Package manager agnostic**: Supports pacman, apt, pkg (Termux), yay, paru
- **Safe defaults**: Includes security checks and fallbacks for missing tools
- **Enhanced aliases**: Better replacements for common commands using modern tools
- **Universal functions**: Backup, copy, and cleanup functions that work everywhere

## Supported Environments

- **Arch Linux** (and derivatives like Garuda, Manjaro)
- **Ubuntu/Debian** (and derivatives)
- **Termux** (Android)
- **Generic Linux** (fallback support)

## Installation

### Quick Setup

1. Copy the files to your fish config directory:
   ```fish
   # On most Linux systems
   cp config_portable.fish ~/.config/fish/config.fish
   
   # On Termux
   cp config_portable.fish $PREFIX/etc/fish/config.fish
   # or
   cp config_portable.fish ~/.config/fish/config.fish
   ```

2. Or use the automated setup script:
   ```fish
   fish setup_fish.fish
   ```

### Manual Installation

1. **Create the fish config directory** (if it doesn't exist):
   ```bash
   # Linux
   mkdir -p ~/.config/fish
   
   # Termux
   mkdir -p ~/.config/fish
   ```

2. **Backup your existing config** (if you have one):
   ```bash
   cp ~/.config/fish/config.fish ~/.config/fish/config.fish.backup
   ```

3. **Copy the portable config**:
   ```bash
   cp config_portable.fish ~/.config/fish/config.fish
   ```

## Environment-Specific Features

### Termux (Android)
- Uses `$PREFIX/bin` paths
- Package management with `pkg` command
- No sudo-based operations
- Adapted file permissions

### Arch Linux
- pacman/yay/paru integration
- Reflector mirror management
- Orphaned package cleanup
- Garuda-specific updates (if available)

### Ubuntu/Debian
- apt package management
- Automatic package cleanup
- System-specific paths

## Recommended Packages

The config works best with these optional packages:

### Essential Tools
- **starship**: Modern shell prompt
- **zoxide**: Smart directory navigation
- **eza**: Modern ls replacement
- **bat**: Cat with syntax highlighting
- **fastfetch**: System information display

### Installation Commands

**Termux:**
```bash
pkg install starship zoxide eza bat fastfetch
```

**Arch Linux:**
```bash
sudo pacman -S starship zoxide eza bat fastfetch
# or with AUR helper
yay -S starship zoxide eza bat fastfetch
```

**Ubuntu/Debian:**
```bash
# Some packages might need different installation methods
sudo apt install bat eza
# starship, zoxide, fastfetch might need manual installation or different repositories
```

## Key Features

### Universal Aliases
- Navigation: `..`, `...`, `....`, etc.
- Package management: `install`, `update`, `search`, `remove` (adapts to system)
- Enhanced commands: `ls` → `eza`, `cat` → `bat`, `grep` → `ugrep`

### Cross-Platform Functions
- `backup <file>`: Create `.bak` copy of file
- `copy <source> <dest>`: Enhanced copy with safety checks
- `cleanup`: Remove orphaned packages (adapts to package manager)

### Environment Detection
The config automatically detects:
- Termux environment
- Available package managers
- Installed tools and utilities
- System-specific paths

## Customization

### Adding Distribution-Specific Code
```fish
# Example: Add custom aliases for a specific distribution
if test $is_arch -eq 0
    # Arch-specific aliases
    alias myalias 'my command'
end
```

### Adding Your Own Functions
Add your custom functions at the end of the config file, or create separate files in `~/.config/fish/functions/`.

## File Structure

- `config_portable.fish`: Main portable configuration
- `setup_fish.fish`: Automated setup script
- `README.md`: This documentation

## Troubleshooting

### Config Not Loading
- Ensure fish is your default shell: `chsh -s $(which fish)`
- Check file permissions: `chmod 644 ~/.config/fish/config.fish`
- Test config manually: `source ~/.config/fish/config.fish`

### Missing Tools
- The config gracefully handles missing tools
- Use the setup script to see what's missing: `fish setup_fish.fish`
- Install recommended packages for the best experience

### Termux Specific Issues
- Some packages might have different names in Termux
- Use `pkg search <tool>` to find the correct package names
- Some desktop-oriented tools might not be available

## Migration from Existing Config

If you have an existing fish config:

1. **Backup your current config**:
   ```bash
   cp ~/.config/fish/config.fish ~/.config/fish/config.fish.old
   ```

2. **Merge custom functions**: Copy any personal functions from your old config to the new one

3. **Test thoroughly**: Make sure all your workflows still work

4. **Gradual adoption**: You can temporarily source both configs to test

## Contributing

Feel free to improve the config for additional distributions or add new features. The goal is maximum portability while maintaining functionality.

## License

This configuration is provided as-is for personal use. Modify and distribute freely.
