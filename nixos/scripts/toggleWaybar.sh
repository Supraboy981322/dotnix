#!/usr/bin/env bash

kill -s SIGUSR1 $(pidof waybar) \
  || err_window "failed to send restart signal to waybar"
