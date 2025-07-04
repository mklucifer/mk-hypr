#!/bin/bash

tooltip="$(playerctl metadata artist) - $(player metadata title) - $(player metadata album)"
text="$(playerctl metadata artist) - $(playerctl metadata title)"

echo "{\"text\": \"$text\", \"tooltip\": \"$tooltip\"}"
