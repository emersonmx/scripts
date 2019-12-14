#!/bin/bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export ZSH_TMUX_AUTOSTART=false
alacritty \
    --config-file "$script_dir/alacritty.yml" \
    -e "$script_dir/window_switcher.sh"
