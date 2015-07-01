#!/bin/bash

if [[ $# = 0 ]]; then
    echo "Usage: $0 <files>"
    exit 1
fi

ctags --c++-kinds=+p --c-kinds=+p --fields=+liaS --extra=+q $*
