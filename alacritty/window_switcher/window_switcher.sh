#!/bin/bash

ignore_ids="0x[a-f0-9]+\s+"
wid=$(wmctrl -l \
    | awk '{$2=$3=""; print $0}' \
    | sed -r \
        -e '/^'$ignore_ids'Área de trabalho$/Id' \
        -e '/^'$ignore_ids'Desktop$/Id' \
        -e '/^'$ignore_ids'FZF$/d' \
    | fzf --layout=reverse --with-nth 2.. \
    | awk '{print $1}' \
)

if [[ -z $wid ]]
then
    exit
fi

wmctrl -ia $wid
sleep 0.1
wmctrl -i -a $wid
