#!/bin/bash

if [[ $(pgrep xfce4-panel) ]]
then
    xfce4-panel -q
else
    xfce4-panel
fi
