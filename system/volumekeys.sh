#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Arbitrary but unique message id
msgId="991049"

amixer set Master "$@" > /dev/null

# Query amixer for the current volume and whether or not the speaker is muted
volume="$(amixer get Master | tail -1 | awk '{print $5}' | sed 's/[^0-9]*//g')"
mute="$(amixer get Master | tail -1 | awk '{print $6}' | sed 's/[^a-z]*//g')"
if [[ $volume == 0 || "$mute" == "off" ]]
then
    # Show the sound muted notification
    dunstify -a "changeVolume" -u low -i audio-volume-muted -r "$msgId" "Volume muted"
else
    # Show the volume notification
    dunstify -a "changeVolume" -u low -i audio-volume-high -r "$msgId" \
        -h int:value:"$volume" "Volume: ${volume}%"
fi
