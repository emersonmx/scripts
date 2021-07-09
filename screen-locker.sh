#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

UPTIME_TIMESTAMP="$(uptime -s | sed 's/[^0-9]//g')"
TMPBG="/tmp/screen_$UPTIME_TIMESTAMP.png"
WALLPAPER_IMAGE="/tmp/wallpaper_$UPTIME_TIMESTAMP.jpg"

alpha='dd'
color1='#1d2021'
color2='#37393A'
color3='#505253'
color4='#6A6B6C'
color5='#838585'
color6='#9D9E9E'
color7='#B6B7B7'
color8='#d0d0d0'

REMOVE_TMPBG=1
if [[ -f "$WALLPAPER_IMAGE" ]]
then
    TMPBG="$WALLPAPER_IMAGE"
    REMOVE_TMPBG=0
else
    scrot $TMPBG && convert $TMPBG -scale 5% -scale 2000% $TMPBG
fi

i3lock \
    --image "$TMPBG" \
    --insidever-color=$color1$alpha \
    --insidewrong-color=$color1$alpha \
    --inside-color=$color1$alpha \
    --ringver-color=$color3 \
    --ringwrong-color=$color3 \
    --ringver-color=$color3 \
    --ringwrong-color=$color3 \
    --ring-color=$color3 \
    --line-uses-inside \
    --keyhl-color=$color7 \
    --bshl-color=$color5 \
    --separator-color=00000000 \
    --verif-color=$color8 \
    --wrong-color=$color8 \
    --layout-color=$color3 \
    --date-color=$color8 \
    --time-color=$color8 \
    --clock \
    --indicator \
    --time-str="%R" \
    --date-str="%A, %d %B %Y" \
    --verif-text="Verifying..." \
    --wrong-text="Auth Failed" \
    --noinput="No Input" \
    --lock-text="Locking..." \
    --lockfailed-text="Lock Failed" \
    --time-font="Roboto" \
    --date-font="Roboto" \
    --layout-font="Roboto" \
    --verif-font="Roboto" \
    --wrong-font="Roboto" \
    --radius=100 \
    --ring-width=20 \
    --pass-media-keys \
    --pass-screen-keys \
    --pass-volume-keys

[[ $REMOVE_TMPBG == 1 ]] && rm "$TMPBG"
