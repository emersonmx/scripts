#!/bin/bash

interval=3

nvim \
    +PlugInstall \
    +"sleep $interval" \
    +PlugUpdate \
    +"sleep $interval" \
    +UpdateRemotePlugins \
    +"sleep $interval" \
    +qall
nvim \
    +CocUpdateSync \
    +"sleep $interval" \
    +qall
