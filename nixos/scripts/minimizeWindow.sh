#!/usr/bin/env bash
xdotool \
    windowunmap \
    $(xdotool getactivewindow) \
  || err_window "failed to minimize"

