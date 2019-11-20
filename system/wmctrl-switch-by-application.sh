#!/bin/bash

direction="$1"

case $direction in
    next|previous)
        ;;
    *)
        echo "Usage: $0 (next|previous)"
        exit
        ;;
esac

# get id of the focused window
active_win_id=$(xprop -root | grep '^_NET_ACTIVE_W' | awk -F'# 0x' '{print $2}')

# get window manager class of current window
win_class=$(wmctrl -x -l | grep $active_win_id | awk '{print $2 " " $3}' )

# get list of all windows matching with the class above
win_list=$(wmctrl -x -l | grep  "$win_class" | awk '{print $1}' )

# get next window to focus on

switch_to=""
case $direction in
    next)
        switch_to=$(echo $win_list | sed -r s/.*$active_win_id// | awk '{print $1}')
        if [[ -z $switch_to ]]; then
            switch_to=$(echo $win_list | awk '{print $1}')
        fi
        ;;
    previous)
        switch_to=$(echo $win_list | sed -r s/\\w+$active_win_id.*// | awk '{print $NF}')
        if [[ -z $switch_to ]]; then
            switch_to=$(echo $win_list | awk '{print $NF}')
        fi
        ;;
esac

# switch to window
wmctrl -i -a $switch_to
