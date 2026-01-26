#!/usr/bin/env bash

# wallpaper-theme-selector

#================================================
# Export paths, for 'wal', it was not being recognized
# as a command when launching via keybind on sway/conf.d/keybinds
#================================================
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export PATH=$PATH:$HOME/.local/bin:/usr/local/bin


#================================================
# DIRECTORIES
#================================================
TMP_CHOICE="/tmp/wallpaper_selection_result"


#================================================
# Run the selector
#================================================
$HOME/.config/de-themes/wallpaper-selector.sh


#================================================
# Apply the colors via 'wal' and reload
#================================================
if [ -f "$TMP_CHOICE" ]; then
    SELECTED=$(cat "$TMP_CHOICE")
    FULL_PATH="$HOME/Pictures/Wallpapers/$SELECTED"

    wal --backend haishoku -i "$FULL_PATH" -n
    
    # Refresh Waybar
    pkill -USR2 waybar
    
    # Clean up
    rm "$TMP_CHOICE"
    echo "Success: $SELECTED applied."
else
    echo "Selection cancelled or failed."
fi