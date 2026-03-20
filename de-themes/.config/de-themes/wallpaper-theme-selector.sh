#!/usr/bin/env bash

# Standardize environment for keybind execution
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export PATH=$PATH:$HOME/.local/bin:/usr/local/bin

TMP_CHOICE="/tmp/wallpaper_selection_result"
WALL_DIR="$HOME/Pictures/Wallpapers"

#================================================
# Run the selector (Wait for user input)
#================================================
$HOME/.config/de-themes/wallpaper-selector.sh

#================================================
# Apply the colors via 'wal'
#================================================
if [ -s "$TMP_CHOICE" ]; then
    SELECTED=$(cat "$TMP_CHOICE")
    FULL_PATH="${WALL_DIR}/${SELECTED}"

    if [ -f "$FULL_PATH" ]; then
        # Apply colors silently
        wal --backend haishoku -i "$FULL_PATH" -n
        
        # Refresh Waybar (if running)
        pgrep -x waybar > /dev/null && pkill -USR2 waybar
        
        # Clean up
        rm "$TMP_CHOICE"
        echo "Success: $SELECTED applied."
    else
        echo "Error: Image file not found at $FULL_PATH"
    fi
else
    echo "Selection cancelled."
fi