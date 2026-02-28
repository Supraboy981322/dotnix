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

hyprPaper() {
  hyprpaper
}

startMako() {
  mako
}

confDisplay() {
  xrandr \
    --output \
    $(getMonitorByDesc "LG Electronics LG ULTRAGEAR 209NTNH3L775") \
    --primary
}

HyprCTL() {
  hyprctl \
    setcursor Bibata-Modern-Ice 12
}

batWarn() {
  battery_notifier
}

mute_volume() {
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 0
}

Kanata() {
  kanata -c ~/.config/kanata.kbd
}

hyprPaper \
  & confDisplay \
  & startMako \
  & HyprCTL \
  & batWarn \
  & mute_volume \
  & wayBar \
  & Kanata
