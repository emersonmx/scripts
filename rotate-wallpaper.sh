#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [[ $# < 1 ]]
then
    echo "Usage: $0 WIDTHxHEIGHT [tags]"
    exit 1
fi

PID=$(pgrep xfce4-session)
export DBUS_SESSION_BUS_ADDRESS="$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ | tr -d '\0' |cut -d= -f2-)"

UPTIME_TIMESTAMP="$(uptime -s | sed 's/[^0-9]//g')"
WALLPAPER_IMAGE="/tmp/wallpaper_$UPTIME_TIMESTAMP.jpg"
SCREEN_SIZE="$1"
IMAGE_TAGS="${2:-}"
FETCH_IMAGE_TIMEOUT=5

curl \
    --location \
    --output "$WALLPAPER_IMAGE" \
    --max-time $FETCH_IMAGE_TIMEOUT \
    "https://source.unsplash.com/$SCREEN_SIZE/?$IMAGE_TAGS" \
    || true

xfconf-query --channel xfce4-desktop --list | grep last-image | while read path
do
    xfconf-query --channel xfce4-desktop --property $path --set "$WALLPAPER_IMAGE"
done
