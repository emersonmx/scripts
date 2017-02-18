#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <servername> <args>"
    exit 1
fi

servername=$1
shift

gvim --servername $servername --remote $@ &

exit 0
