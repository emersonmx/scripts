#!/bin/bash

#!/bin/sh

case $1 in
   "play")
       action="PlayPause"
       ;;
   "next")
       action="Next"
       ;;
   "prev")
       action="Previous"
       ;;
   *)
       echo "Usage: $0 play|next|prev"
       exit 1
        ;;
esac
dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.$action
exit 0
