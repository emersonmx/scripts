#!/bin/bash

case $1 in
   "play-pause")
       dbusAction="PlayPause"
       xdotAction="XF86AudioPlay"
       ;;
   "next")
       dbusAction="Next"
       xdotAction="XF86AudioNext"
       ;;
   "previous")
       dbusAction="Previous"
       xdotAction="XF86AudioPrev"
       ;;
   *)
       echo "Usage: $0 play-pause|next|previous"
       exit 1
        ;;
esac

xdotool key --window $(xdotool search --name "mpv" | head -n 1) $xdotAction > /dev/null 2>&1
dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.$dbusAction > /dev/null 2>&1

exit 0
