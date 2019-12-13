#!/bin/bash

window=$(wmctrl -l \
    | awk '{$2=$3=""; print $0}' \
    | sed -r \
        -e '/0x[a-f0-9]+\s+(Área de trabalho|Desktop|FZF)$/d' \
    | fzf --layout=reverse --with-nth 2.. \
    | awk '{print $1}'
)

wmctrl -i -a $window
