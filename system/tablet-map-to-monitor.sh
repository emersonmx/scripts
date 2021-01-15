#!/bin/bash
# set -euo pipefail
# IFS=$'\n\t'

stylus_device=$(xsetwacom list devices | grep "type: STYLUS" | sed -r 's/.*id: ([0-9]+).*/\1/g')
prop_ctm_id=$(xinput list-props 22 | grep 'Coordinate Transformation Matrix' | sed -r 's/.*\(([0-9]+)\).*/\1/')
monitors=$(xrandr --listmonitors | sed '1 d' | awk '{print $4}' | head -n2)
primary_monitor=$(echo $monitors | cut -d' ' -f1)
secondary_monitor=$(echo $monitors | cut -d' ' -f2)

option=$(printf "Primary\nSecondary\nBoth" | rofi -dmenu -p "How monitor to map the tablet? " -i)

case $option in
    Primary)
        xsetwacom set $stylus_device MapToOutput $primary_monitor
        ;;
    Secondary)
        echo Switch to secondary monitor
        xsetwacom set $stylus_device MapToOutput $secondary_monitor
        ;;
    Both)
        xinput set-prop $stylus_device $prop_ctm_id 1.000304 0 0 0 1 0 0 0 1
        ;;
esac
