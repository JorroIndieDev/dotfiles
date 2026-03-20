#!/usr/bin/env bash

#================================================
# DIRECTORIES
#================================================
WALL_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/rofi_test"
THUMB_DIR="$CACHE_DIR/thumbs"
LIST_FILE="$CACHE_DIR/preview_list.txt"
TEMP_LIST=$(mktemp)

mkdir -p "$THUMB_DIR"

#================================================
# ARGUMENT PARSING
#================================================
FORCE=false
while getopts "f" opt; do
  case $opt in
    f) FORCE=true ;;
    *) echo "Usage: $0 [-f]"; exit 1 ;;
  esac
done

echo "Caching thumbnails..."

#================================================
# GENERATE THUMBNAILS & LIST
#================================================
# We wrap the loop to redirect output to TEMP_LIST all at once
{
    find -L "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" \) | while read -r img; do
        filename=$(basename "$img")
        thumb_file="$THUMB_DIR/$filename.png"

        # Only generate if forced or if thumbnail doesn't exist
        if [ "$FORCE" = true ] || [ ! -f "$thumb_file" ]; then
            magick "$img" -thumbnail 300x300 "$thumb_file"
        fi
        
        # Rofi syntax: <display_text>\0icon\x1f<path_to_icon>\n
        printf "%s\0icon\x1f%s\n" "$filename" "$thumb_file"
    done
} > "$TEMP_LIST"

# Move the completed list into place atomically
mv "$TEMP_LIST" "$LIST_FILE"

echo "Done."