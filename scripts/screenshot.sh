#!/usr/bin/env bash

filename="$(date "+%y%_m%_d_%H%M%S").png"
filepath="/home/super/Pictures/Screenshots/${filename}"

if [[ "$1" == "select" ]]; then
  hyprshot \
    -m region \
    -r - > ${filepath}
else
  hyprshot \
    -m active \
    -m output \
    -r - > ${filepath}
fi

notify-send "Screenshot" "Saved to:\n~/IMG/Screen/${filename}"
