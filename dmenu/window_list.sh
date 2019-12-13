#!/bin/bash

window="$(wmctrl -l \
    | awk '{$1=$2=$3=""; print $$0}' \
    | sed -r \
        -e 's/^\s+//' \
        -e '/^(Área de trabalho|Desktop)$/Id' \
    | sort \
    | dmenu -i -l 5 \
)"

wmctrl -a $window
