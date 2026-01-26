#!/bin/sh
# Copy pywal-generated sway colors to the active config location
cp ~/.cache/wal/colors-sway ~/.config/sway/colors.d/current.conf

# Reload sway to apply new colors
swaymsg reload
