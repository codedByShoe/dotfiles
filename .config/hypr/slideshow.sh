#!/bin/bash

# Configuration
interval=900 # 15 mins
wallpaperDir="$HOME/Wallpapers"

# Function to filter and get only image files .jpg not supported!
get_wallpapers() {
  find "$wallpaperDir" -type f \( -iname "*.jpeg" -o -iname "*.png" \)
}

# Function to set wallpaper
set_wallpaper() {
  local img="$1"
  if [ -f "$img" ]; then
    swww img "$img"
  fi
}

while true; do
  wallpapers=$(get_wallpapers)
  if [ -z "$wallpapers" ]; then
    echo "No wallpapers found in $wallpaperDir" >&2
    sleep "$interval"
    continue
  fi

  echo "$wallpapers" | shuf | while read -r img; do
    set_wallpaper "$img"
    sleep "$interval"
  done
done
