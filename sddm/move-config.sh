#!/bin/bash

# --- CONFIGURATION ---
# Change this to your specific destination path
TARGET_DIR="/usr/share/sddm/themes/silent/configs/"
# ---------------------

# 1. Check if a filename was provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file_to_copy>"
    exit 1
fi

SOURCE_FILE=$1

# 2. Check if the source file actually exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: File '$SOURCE_FILE' not found."
    exit 1
fi

# 3. Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Target directory '$TARGET_DIR' does not exist."
    exit 1
fi

# 4. Perform the copy
# -f: Force overwrite if the file already exists in the destination
# -p: Preserve file attributes (timestamps, permissions)
cp -fp "$SOURCE_FILE" "$TARGET_DIR/"

echo "Success: Copy of '$SOURCE_FILE' placed in '$TARGET_DIR'."