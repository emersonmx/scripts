#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GAME_DIR="$SCRIPT_DIR/Game"

# cd "$GAME_DIR"
# wine "$GAME_DIR/Game.exe" -w $@

cd "$GAME_DIR/Mod PlugY/"
wine "$GAME_DIR/Mod PlugY/PlugY.exe" $@

windows=
for i in $(seq 1 5)
do
    sleep $i
    if  pgrep 'Game.exe' > /dev/null
    then
        windows=$(wmctrl -l | sed -r '/Diablo II/!d' | cut -d' ' -f1 | tac)
        break
    fi
done

for w in $windows
do
    if xprop -id $w WM_CLASS | grep game.exe
    then
        wmctrl -i -a "$w"
        break
    fi
done
