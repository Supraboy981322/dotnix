#!/usr/bin/env bash


wayBar() {
  pkill waybar
  waybar \
    --style /home/super/.config/hypr/waybar.css \
    --config /home/super/.config/hypr/waybar.jsonc
}

hyprPaper() {
  pkill hyprpaper
  hyprpaper
}

startMako() {
  pkill mako
  mako
}

batWarn() {
  pkill batter_notifier
  battery_notifier
}

dns_monitor() {
  pkill internet_connection_checker_thingy
  internet_connection_checker_thingy
}

Kanata() {
  pkill kanata
  kanata -c ~/.config/kanata.kbd
}

hyprPaper \
  & startMako \
  & batWarn \
  & wayBar \
  & Kanata \
  & dns_monitor
