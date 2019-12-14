#!/bin/bash

id_regex="0x[a-f0-9]+"
window=$(wmctrl -l \
    | awk '{$2=$3=""; print $0}' \
    | sed -r \
        -e '/^'$id_regex'\s+Área de trabalho$/Id' \
        -e '/^'$id_regex'\s+Desktop$/Id' \
        -e '/^'$id_regex'\s+FZF$/d' \
    | fzf --layout=reverse --with-nth 2.. \
    | awk '{print $1}' \
)

wmctrl -i -a $window
