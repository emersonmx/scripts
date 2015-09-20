#!/bin/bash

xfce4-terminal -x $SHELL -c "TERM=xterm-256color vim $(printf "%q " "$@")"
