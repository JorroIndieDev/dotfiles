#!/usr/bin/env bash

# wallpaper-selector

# Run thumbnail cache in background
$HOME/.config/de-themes/wallpaper-thumbnail-cache.sh > /dev/null 2>&1 &

#================================================
# DIRECTORIES
#================================================
WALL_DIR="$HOME/Pictures/Wallpapers"
LIST_FILE="$HOME/.cache/rofi_test/preview_list.txt"
TMP_CHOICE="/tmp/wallpaper_selection_result"

# Clear any old selection
rm -f "$TMP_CHOICE"

#================================================
# Launch wallpaper selector
#================================================
SELECTED=$(rofi -dmenu -i -p "View Wallpapers" \
    -show-icons \
    -input "$LIST_FILE" \
    -theme "$HOME/.config/rofi/wallpaper-grid.rasi")

#================================================
# Write the chosen wallpaper to the cache files
#================================================
if [ -n "$SELECTED" ]; then
    # this is for the reboot file, its required to apply the wallpaper on boot
    echo "$SELECTED" > "$HOME/.config/de-themes/applied_wallpaper"

    echo "$SELECTED" > "$TMP_CHOICE"

    swww img "${WALL_DIR}/${SELECTED}" --transition-type grow
    exit 0
else
    exit 1
fi