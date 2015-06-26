#!/bin/bash

terminal="xfce4-terminal"
terminal_pid=`pgrep $terminal`

if [[ ! -z $terminal_pid ]]; then
    wmctrl -x -a $terminal
else
    $terminal $* &
fi
