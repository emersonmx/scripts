#!/bin/bash

interval=3

nvim \
    +PlugInstall \
    +"sleep $interval" \
    +PlugUpdate \
    +"sleep $interval" \
    +qall
nvim \
    +CocUpdateSync \
    +"sleep $interval" \
    +qall
