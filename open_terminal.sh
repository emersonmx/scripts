#!/bin/bash

terminal='xfce4-terminal'
terminal_wm_class='xfce4-terminal.Xfce4-terminal'

if [[ $# != 2 && $# != 0 ]]; then
    echo "Usage: $0 <terminal> <terminal_wm_class>"
    exit
fi

wmctrl -xa $terminal_wm_class 
retval=$?
if [[ $retval -ne 0 ]]; then 
    $terminal &
fi
