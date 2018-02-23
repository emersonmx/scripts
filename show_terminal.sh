#!/bin/bash

terminal="terminator"
terminal_pid=`pgrep $terminal`

if [[ ! -z $terminal_pid ]]; then
    wmctrl -x -a $terminal
else
    $terminal $* &
fi
