#!/bin/bash
spotify_id=$(wpctl status | awk '/^\s*[0-9]+\.\s*spotify\s*$/ {print $1}' | tr -d '.')
if [ -n "$spotify_id" ]; then
    wpctl set-volume "$spotify_id" 0.02-
fi

