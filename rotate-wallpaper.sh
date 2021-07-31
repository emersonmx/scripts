#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [[ $# < 1 ]]
then
    echo "Usage: $0 WIDTHxHEIGHT [tags]"
    exit 1
fi

PID=$(pgrep bspwm)
export DBUS_SESSION_BUS_ADDRESS="$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ | tr -d '\0' |cut -d= -f2-)"

UPTIME_TIMESTAMP="$(uptime -s | sed 's/[^0-9]//g')"
WALLPAPER_IMAGE="/tmp/wallpaper_$UPTIME_TIMESTAMP.jpg"
SCREEN_SIZE="$1"
IMAGE_TAGS="${2:-}"
FETCH_IMAGE_TIMEOUT=5

[[ ! -f "$WALLPAPER_IMAGE" ]] \
    && convert -size "$SCREEN_SIZE" xc:#000000 "$WALLPAPER_IMAGE" \
    && feh --bg-fill "$WALLPAPER_IMAGE"

curl \
    --location \
    --output "$WALLPAPER_IMAGE" \
    --max-time $FETCH_IMAGE_TIMEOUT \
    "https://source.unsplash.com/$SCREEN_SIZE/?$IMAGE_TAGS" \
    || true


feh --bg-fill "$WALLPAPER_IMAGE"
