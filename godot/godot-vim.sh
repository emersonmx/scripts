#!/bin/bash

if [[ $# == 0 ]]; then
    /usr/bin/vim --servername godot-vim
else
    /usr/bin/vim --servername godot-vim --remote-silent "$@"
fi

system_path="$(dirname $(dirname $(readlink -f $0)))/system"
$system_path/open.sh xfce4-terminal
