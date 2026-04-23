#!/usr/bin/env bash

#used to get the name of a monitor
#  which reports a different name
#    at each boot
getMonitorByDesc() (
  set -eou pipefail
  #get the monitors' data as JSON
  json="$(hyprctl monitors -j)"

  #get the descriptions
  descs="$(printf "${json}" \
    | jq -r '.. | .description? // empty')"

  #get the index of the descriptions
  num=$(($(printf "${descs}" \
    | grep -n "$1")-1))

  #get the name using the index 
  name=$(printf "${json}" \
    | jq -r ".[$num].name")

  #return the value
  printf "${name}"
)

wayBar() {
  waybar \
    --style /home/super/.config/hypr/waybar.css \
    --config /home/super/.config/hypr/waybar.jsonc
}

confDisplay() {
  xrandr \
    --output \
    $(getMonitorByDesc "LG Electronics LG ULTRAGEAR 209NTNH3L775") \
    --primary
}

declare commands=(
  "hyprpaper"
  "confDisplay"
  "mako"
  "hyprctl setcursor Bibata-Modern-Ice 12"
  "battery_notifier"
  "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0"
  "wayBar"
  "kanata -c ~/.config/kanata.kbd"
  "internet_connection_checker_thingy"
)
for cmd in "${commands[@]}"; do
  ($cmd || err_window "failed to start: $cmd") & :
done
