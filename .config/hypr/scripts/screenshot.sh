#!/usr/bin/env bash

# Directory for persistent screenshots
SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

# Timestamped filename
FILENAME="$(date +'%Y-%m-%d_%H-%M-%S').png"
FULLPATH="$SAVE_DIR/$FILENAME"

# Capture mode (first argument: screen / area / active / output)
MODE="$1"

# Take screenshot
grimblast save "$MODE" "$FULLPATH"

# Copy to clipboard
wl-copy < "$FULLPATH"

# Notify
notify-send "Screenshot saved and copied" "$FULLPATH"

