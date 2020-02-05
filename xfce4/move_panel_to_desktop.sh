#!/bin/bash

panel_count=1
panel_name="xfce4-panel"

# Wait for all panels to load
while [ "$(wmctrl -l | grep -c $panel_name)" -lt "$panel_count" ];
do
    echo 'Waiting panels...'
    sleep 0.05
done

# Determine identifier
ID=$(wmctrl -l | grep "$panel_name"$ | sed -n "$panel_count"p | awk '{ print $1 }')

# Place panel at desktop-level
wmctrl -i -r $ID -b add,below
