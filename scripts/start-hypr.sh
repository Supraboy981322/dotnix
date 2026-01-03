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
    --style ~/.config/hypr/waybar.css \
    --config ~/.config/hypr/waybar.jsonc
}

hyprPaper() {
  hyprpaper
}

startMako() {
  mako
}

confDisplay() {
  xrandr \
    --output \
    $(getMonitorsByDesc "LG Electronics LG ULTRAGEAR 209NTNH3L775") \
    --primary
}

HyprCTL() {
  hyprctl \
    setcursor Bibata-Modern-Ice 12
}

batWarn() {
  /home/super/scripts/battery_notifier
}

wayBar \
  & hyprPaper \
  & confDisplay \
  & startMako \
  & hyprCTL \
  & batWarn 
