#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SHELL=/bin/zsh
EDITOR=nvim

if ! [ -x "$(command -v notify-send)" ]
then
    echo 'notify-send não encontrado!'
    exit
fi

if ! [ -x "$(command -v tmux)" ]
then
    echo 'TMUX não encontrado!'
    exit
fi

if ! [ -x "$(command -v wmctrl)" ]
then
    echo 'wmctrl não encontrado!'
    exit
fi

notify-send "Arquivo aberto no tmux"
wmctrl -a $SHELL
tmux new-window $EDITOR $@
