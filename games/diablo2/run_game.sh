#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GAME_DIR="$SCRIPT_DIR/Game"

# cd "$GAME_DIR"
# wine "$GAME_DIR/Game.exe" -w $@

cd "$GAME_DIR/ModPlugY/"
wine "$GAME_DIR/ModPlugY/PlugY.exe" -direct -txt $@

while [[ ! $(pgrep 'Game.exe') ]]
do
    sleep 1
done

sleep 1
wmctrl -a "Diablo II"
sleep 1
wmctrl -a "Diablo II"
