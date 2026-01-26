#!/usr/bin/env bash

# wallpaper-thumbnail-cache

#Debug line
echo "Caching thumbnails..."
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

#Debug line
if [ "$FORCE" = true ]; then
    echo "Caching thumbnails (FORCED)..."
else
    echo "Caching thumbnails..."
fi
#================================================
# DIRECTORIES
#================================================
WALL_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/rofi_test"
THUMB_DIR="$CACHE_DIR/thumbs"
LIST_FILE="$CACHE_DIR/preview_list.txt"

mkdir -p "$THUMB_DIR"
> "$LIST_FILE"

find "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" \) | while read -r img; do
    filename=$(basename "$img")
    thumb_file="$THUMB_DIR/$filename.png"

    if [ "$FORCE" = true ] || [ ! -f "$thumb_file" ]; then
        magick "$img" -thumbnail 300x300 "$thumb_file"
    fi
    echo -en "$filename\0icon\x1f$thumb_file\n" >> "$LIST_FILE"
done

echo "Done"
