#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if ! [ -x "$(command -v tmux)" ]
then
    echo 'TMUX não encontrado!'
    exit
fi

tmux new-window $EDITOR $@
