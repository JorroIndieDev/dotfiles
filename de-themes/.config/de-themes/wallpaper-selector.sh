#!/usr/bin/env bash

# Run thumbnail cache in background (silently)
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
# If the list is empty (first run), wait for cache to finish
if [ ! -s "$LIST_FILE" ]; then
    echo "First run: generating cache..."
    $HOME/.config/de-themes/wallpaper-thumbnail-cache.sh
fi

# Pass the list file to Rofi
SELECTED=$(rofi -dmenu -i -p "View Wallpapers" \
    -show-icons \
    -theme "$HOME/.config/rofi/wallpaper-grid.rasi" < "$LIST_FILE")

#================================================
# Handle Selection
#================================================
if [ -n "$SELECTED" ]; then
    # Save selection for other scripts
    echo "$SELECTED" > "$HOME/.config/de-themes/applied_wallpaper"
    echo "$SELECTED" > "$TMP_CHOICE"

    # Set the wallpaper
    swww img "${WALL_DIR}/${SELECTED}" --transition-type grow
    exit 0
else
    exit 1
fi