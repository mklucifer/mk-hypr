#!/bin/bash

# Original wallpaper input
original_wallpaper="$1"

# Destination to also save it
destination_dir="$HOME/.config/themes/"
mkdir -p "$destination_dir"

# Copy it there
cp "$original_wallpaper" "$destination_dir/current-wallpaper.png"

# Call matugen as usual
matugen image "$original_wallpaper" 

