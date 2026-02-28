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

Kanata() {
  pkill kanata
  kanata -c ~/.config/kanata.kbd
}

hyprPaper \
  & startMako \
  & batWarn \
  & wayBar \
  & Kanata
