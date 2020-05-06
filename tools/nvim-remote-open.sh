#!/bin/bash

function exit_if_not_exists() {
    if [ ! -x "$(command -v $1)" ]
    then
        echo "$1 not found!"
        notify-send "$1 not found!"
        exit
    fi
}

function wait_custom_command() {
    until [[ $(eval "$1") ]]
    do
        echo "waiting $1"
        notify-send "waiting $1"
        sleep 1
    done
}

function wait_command() {
    until [[ $(pidof $1) ]]
    do
        echo "waiting $1"
        notify-send "waiting $1"
        sleep 1
    done
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
socket_id="$(printf "%s" $PWD | sha1sum | cut -d' ' -f1)"
socket="/tmp/nvim-remote-$socket_id"

editor=${EDITOR:-vi}
terminal=${TERMINAL:-xterm}

exit_if_not_exists $terminal
exit_if_not_exists $editor
exit_if_not_exists tmux
exit_if_not_exists wmctrl

if [[ ! $(pidof $terminal) ]]
then
    $terminal > /dev/null 2>&1 &
fi

wait_command tmux
wait_custom_command "tmux list-sessions"

nvr --servername $socket --nostart $*

wmctrl -i -a $(wmctrl -l | grep -i $terminal | grep -v wmctrl | cut -d' ' -f1)
