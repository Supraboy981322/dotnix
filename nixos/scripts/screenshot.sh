#!/usr/bin/env bash

filename="$(date "+%y%_m%_d_%H%M%S").png"
fileDir="/home/super/Pictures/Screenshots"
filepath="${fileDir}/${filename}"

printf "${filename}\n" \
    || err_window "why would printf fail?"

if [[ "$1" == "select" ]]; then
  hyprshot \
      -m region \
      -o ${fileDir} \
      -f "${filename}" \
    || err_window "hyprshot failed"
else
  hyprshot \
      -m active \
      -m output \
      -o ${fileDir} \
      -f "${filename}" \
    || err_window "hyprshot failed"
fi
#notify-send "Screenshot" "Saved to:\n~/IMG/Screen/${filename}"
