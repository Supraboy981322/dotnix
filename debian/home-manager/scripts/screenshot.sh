#!/usr/bin/env bash

filename="$(date "+%y%_m%_d_%H%M%S").png"
fileDir="/home/super/Pictures/Screenshots"
filepath="${fileDir}/${filename}"

printf "${filename}\n"

if [[ "$1" == "select" ]]; then
  hyprshot \
    -m region \
    -o ${fileDir} \
    -f "${filename}"
else
  hyprshot \
    -m active \
    -m output \
    -o ${fileDir} \
    -f "${filename}"
fi
#notify-send "Screenshot" "Saved to:\n~/IMG/Screen/${filename}"
