#!/usr/bin/env bash


wayBar() {
  pkill -9 waybar
  waybar \
    --style /home/super/.config/hypr/waybar.css \
    --config /home/super/.config/hypr/waybar.jsonc
}

hyprPaper() {
  pkill -9 hyprpaper
  hyprpaper
}

startMako() {
  pkill -9 mako
  mako
}

batWarn() {
  pkill -9 batter_notifier
  battery_notifier
}

dns_monitor() {
  pkill -9 internet_connection_checker_thingy
  internet_connection_checker_thingy
}

hyprPaper \
  & startMako \
  & batWarn \
  & wayBar \
  & dns_monitor \
  & (
    pkill -9 kanata
    kanata -c ~/.config/kanata.kbd
  )
