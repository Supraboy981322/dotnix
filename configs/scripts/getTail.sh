#!/bin/bash
tailscale ip "${1}" \
     | sed -n "1p"