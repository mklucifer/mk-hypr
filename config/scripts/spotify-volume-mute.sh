#!/bin/bash
spotify_id=$(wpctl status | awk '/^\s*[0-9]+\.\s*spotify\s*$/ {print $1}' | tr -d '.')
if [ -n "$spotify_id" ]; then
    wpctl set-mute "$spotify_id" toggle
fi

