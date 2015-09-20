#!/bin/bash

ARGS="$@"
xfce4-terminal -x $SHELL -c "TERM=xterm-256color vim $ARGS" && exit
